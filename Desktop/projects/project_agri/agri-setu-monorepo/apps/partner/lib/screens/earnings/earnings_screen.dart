import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import '../../theme/provider_colors.dart';
import '../../widgets/premium_components.dart';
import '../dashboard/widgets/earnings_chart.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = context.read<BookingService>().getBookings();
  }

  Map<String, double> _calculateStats(List<Booking> bookings) {
    double total = 0;
    double pending = 0;
    double thisMonth = 0;
    final now = DateTime.now();

    for (var b in bookings) {
      final amount = b.totalPrice ?? 0;
      if (b.status == 'COMPLETED' || b.status == 'CONFIRMED') {
        total += amount;
        if (b.startTime.month == now.month && b.startTime.year == now.year) {
          thisMonth += amount;
        }
      } else if (b.status == 'PENDING') {
        pending += amount;
      }
    }
    return {'total': total, 'pending': pending, 'thisMonth': thisMonth};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: Text(
          'Earnings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ProviderColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ProviderColors.textPrimary),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bookings = snapshot.data ?? [];
          final stats = _calculateStats(bookings);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Earnings Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: ProviderColors.primaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: ProviderColors.primaryShadow,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Earnings',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹ ${stats['total']!.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(
                            label: 'This Month',
                            value:
                                '₹ ${stats['thisMonth']!.toStringAsFixed(0)}',
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white24,
                          ),
                          _StatItem(
                            label: 'Pending',
                            value: '₹ ${stats['pending']!.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Chart Section
                const SectionHeader(title: 'Analytics'),
                const SizedBox(height: 12),
                const SizedBox(height: 200, child: EarningsChart()),

                const SizedBox(height: 24),

                // Transactions List
                const SectionHeader(title: 'Recent Transactions'),
                const SizedBox(height: 12),
                if (bookings.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        "No transactions yet",
                        style: GoogleFonts.inter(
                          color: ProviderColors.textMuted,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bookings.take(10).length, // Show recent 10
                    itemBuilder: (context, index) {
                      final booking =
                          bookings[bookings.length -
                              1 -
                              index]; // Reverse order
                      if (booking.status == 'PENDING')
                        return const SizedBox.shrink(); // Hide pending from transactions? Or show as pending.

                      return GlassCard(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: booking.status == 'COMPLETED'
                                    ? ProviderColors.success.withOpacity(0.1)
                                    : ProviderColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                booking.status == 'COMPLETED'
                                    ? Icons.check
                                    : Icons.access_time,
                                color: booking.status == 'COMPLETED'
                                    ? ProviderColors.success
                                    : ProviderColors.warning,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.machineDetails?.name ??
                                        'Machine Rental',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: ProviderColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(booking.startTime),
                                    style: GoogleFonts.inter(
                                      color: ProviderColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+ ₹${booking.totalPrice}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: ProviderColors.success,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
