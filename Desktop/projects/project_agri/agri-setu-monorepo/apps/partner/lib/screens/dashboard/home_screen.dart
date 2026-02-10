import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart'; // Import API services
import '../../theme/provider_colors.dart';
import '../../widgets/premium_components.dart';
import 'widgets/earnings_chart.dart';
import '../add_machine_screen.dart';
import '../earnings/earnings_screen.dart';
import '../calendar/calendar_screen.dart';
import '../bookings/bookings_screen.dart';
import '../equipment/my_machines_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Machine>> _machinesFuture;
  late Future<List<Booking>> _bookingsFuture; // For stats
  late Future<Map<String, double>> _earningsDataFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _machinesFuture = context.read<InventoryService>().getMyMachines();
      _bookingsFuture = context.read<BookingService>().getBookings();
      _earningsDataFuture = _calculateEarnings();
    });
  }

  Future<Map<String, double>> _calculateEarnings() async {
    final bookings = await context.read<BookingService>().getBookings();
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
      body: FutureBuilder(
        future: Future.wait([
          _bookingsFuture,
          _earningsDataFuture,
          _machinesFuture,
        ]), // Wait for all likely
        builder: (context, snapshot) {
          // We can use individual futures or just rebuilding.
          // Let's use individual builders where needed for cleaner loading or just one big one.
          // For HomeScreen, a refresh triggers all, so one builder is okay-ish, but let's stick to layout first.

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning,',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: ProviderColors.textSecondary,
                              ),
                            ),
                            // TODO: Fetch Real Name
                            Text(
                              'Partner 👋',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: ProviderColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: ProviderColors.softShadow,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          color: ProviderColors.textPrimary,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Earnings Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FutureBuilder<Map<String, double>>(
                    future: _earningsDataFuture,
                    builder: (context, snapshot) {
                      final earnings =
                          snapshot.data ??
                          {'total': 0, 'pending': 0, 'thisMonth': 0};
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: ProviderColors.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: ProviderColors.primaryShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Earnings',
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                // Trend Badge (Mock for now or calc)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.trending_up,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+12%',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹ ${earnings['total']!.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _EarningsSubStat(
                                    label: 'This Month',
                                    value:
                                        '₹ ${earnings['thisMonth']!.toStringAsFixed(0)}',
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white24,
                                ),
                                Expanded(
                                  child: _EarningsSubStat(
                                    label: 'Pending',
                                    value:
                                        '₹ ${earnings['pending']!.toStringAsFixed(0)}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Quick Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Overview'),
                      const SizedBox(height: 12),
                      FutureBuilder<List<Booking>>(
                        future: _bookingsFuture,
                        builder: (context, bSnapshot) {
                          final bookings = bSnapshot.data ?? [];
                          final active = bookings
                              .where((b) => b.status == 'CONFIRMED')
                              .length;

                          return FutureBuilder<List<Machine>>(
                            future: _machinesFuture,
                            builder: (context, mSnapshot) {
                              final machines = mSnapshot.data ?? [];
                              return Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MyMachinesScreen(),
                                          ),
                                        ).then((_) => _refreshData());
                                      },
                                      child: StatCard(
                                        title: 'Machines',
                                        value: '${machines.length}',
                                        icon: Icons.agriculture,
                                        iconColor: ProviderColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to Bookings with Active tab
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const BookingsScreen(
                                                  initialIndex: 1,
                                                ),
                                          ),
                                        );
                                      },
                                      child: StatCard(
                                        title: 'Active Jobs',
                                        value: '$active',
                                        icon: Icons.work_outline,
                                        iconColor: ProviderColors.accent,
                                        trend: null, // Calc trend if needed
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      // Row 2 of Stats could go here
                    ],
                  ),
                ),
              ),

              // Earnings Chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Weekly Earnings',
                          actionText: 'See All',
                          onAction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EarningsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 180, child: EarningsChart()),
                      ],
                    ),
                  ),
                ),
              ),

              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Quick Actions'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _QuickActionCard(
                            icon: Icons.add_circle_outline,
                            label: 'Add Machine',
                            color: ProviderColors.accent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddMachineScreen(),
                                ),
                              ).then((_) => _refreshData());
                            },
                          ),
                          const SizedBox(width: 12),
                          _QuickActionCard(
                            icon: Icons.calendar_month,
                            label: 'Calendar',
                            color: ProviderColors.secondary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CalendarScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          _QuickActionCard(
                            icon: Icons.support_agent,
                            label: 'Support',
                            color: ProviderColors.info,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}

class _EarningsSubStat extends StatelessWidget {
  final String label;
  final String value;

  const _EarningsSubStat({required this.label, required this.value});

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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: ProviderColors.softShadow,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ProviderColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
