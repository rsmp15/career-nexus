import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import '../../theme/provider_colors.dart';
import '../../widgets/premium_components.dart';

class BookingsScreen extends StatefulWidget {
  final int initialIndex;
  const BookingsScreen({super.key, this.initialIndex = 0});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _refreshBookings();
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = context.read<BookingService>().getBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bookings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ProviderColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: ProviderColors.textPrimary),
            onPressed: _refreshBookings,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: ProviderColors.primary,
          unselectedLabelColor: ProviderColors.textMuted,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.inter(),
          indicatorColor: ProviderColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'History'),
          ],
        ),
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

          final allBookings = snapshot.data ?? [];

          final pending = allBookings
              .where((b) => b.status == 'PENDING')
              .toList();
          final active = allBookings
              .where((b) => b.status == 'CONFIRMED')
              .toList();
          final history = allBookings
              .where(
                (b) =>
                    b.status == 'COMPLETED' ||
                    b.status == 'CANCELLED' ||
                    b.status == 'REJECTED',
              )
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _BookingsList(
                bookings: pending,
                status: 'Pending',
                onRefresh: _refreshBookings,
              ),
              _BookingsList(
                bookings: active,
                status: 'Active',
                onRefresh: _refreshBookings,
              ),
              _BookingsList(
                bookings: history,
                status: 'History',
                onRefresh: _refreshBookings,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<Booking> bookings;
  final String status;
  final VoidCallback onRefresh;

  const _BookingsList({
    required this.bookings,
    required this.status,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No $status bookings',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _BookingCard(booking: booking, onRefresh: onRefresh);
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onRefresh;

  const _BookingCard({required this.booking, required this.onRefresh});

  Future<void> _approveBooking(BuildContext context) async {
    try {
      await context.read<BookingService>().approveBooking(booking.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking Approved')));
      onRefresh();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _rejectBooking(BuildContext context) async {
    try {
      await context.read<BookingService>().rejectBooking(booking.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking Rejected')));
      onRefresh();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _completeBooking(BuildContext context) async {
    try {
      await context.read<BookingService>().completeBooking(booking.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking Completed')));
      onRefresh();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ProviderColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#${booking.id}',
                    style: GoogleFonts.inter(
                      color: ProviderColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM dd, yyyy').format(booking.startTime),
                  style: GoogleFonts.inter(
                    color: ProviderColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: booking.machineDetails?.image != null
                        ? Image.network(
                            booking.machineDetails!.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.agriculture,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.agriculture, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.machineDetails?.name ?? 'Unknown Machine',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: ProviderColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: ProviderColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking.farmerName ?? 'Unknown Farmer',
                            style: GoogleFonts.inter(
                              color: ProviderColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: ProviderColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${booking.duration ?? 0} Days', // Use null-safe access
                            style: GoogleFonts.inter(
                              color: ProviderColors.accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Total: ₹${booking.totalPrice ?? 0}', // Use null-safe access
                            style: GoogleFonts.inter(
                              color: ProviderColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Actions
          if (booking.status == 'PENDING')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectBooking(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      text: 'Accept',
                      onPressed: () => _approveBooking(context),
                    ),
                  ),
                ],
              ),
            )
          else if (booking.status == 'CONFIRMED')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GradientButton(
                text: 'Mark as Completed',
                onPressed: () => _completeBooking(context),
                // Use a different color or style if possible, but GradientButton is standard
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: booking.status == 'CONFIRMED'
                    ? ProviderColors.accent.withOpacity(0.1)
                    : (booking.status == 'COMPLETED'
                          ? ProviderColors.success.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1)),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20), // Match glass card radius
                ),
              ),
              child: Center(
                child: Text(
                  booking.status, // Already UPPERCASE in backend
                  style: GoogleFonts.inter(
                    color: booking.status == 'CONFIRMED'
                        ? ProviderColors.accent
                        : (booking.status == 'COMPLETED'
                              ? ProviderColors.success
                              : Colors.grey),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
