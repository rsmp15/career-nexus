import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import '../../theme/app_design.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/status_chip.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

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
    _tabController = TabController(length: 3, vsync: this);
    _refreshBookings();
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = context.read<BookingService>().getBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.background,
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: AppDesign.headlineMedium.copyWith(
            color: AppDesign.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppDesign.textPrimary),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppDesign.booking,
          unselectedLabelColor: AppDesign.textSecondary,
          indicatorColor: AppDesign.booking,
          indicatorWeight: 3,
          labelStyle: AppDesign.titleMedium,
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
              _BookingList(bookings: pending, onRefresh: _refreshBookings),
              _BookingList(bookings: active, onRefresh: _refreshBookings),
              _BookingList(bookings: history, onRefresh: _refreshBookings),
            ],
          );
        },
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final VoidCallback onRefresh;

  const _BookingList({required this.bookings, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppDesign.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: AppDesign.bodyLarge.copyWith(color: AppDesign.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDesign.spaceM),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return AppDesign.warning;
      case 'CONFIRMED':
        return AppDesign.success;
      case 'COMPLETED':
        return AppDesign.booking; // Use main color
      case 'CANCELLED':
      case 'REJECTED':
        return AppDesign.error;
      default:
        return AppDesign.textSecondary;
    }
  }

  Future<void> _cancelBooking(BuildContext context) async {
    try {
      await context.read<BookingService>().cancelBooking(booking.id);
      onRefresh();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking Cancelled')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to cancel: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(booking.status);
    final isPending = booking.status == 'PENDING';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDesign.spaceM),
      child: GlassCard(
        padding: const EdgeInsets.all(AppDesign.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.id}',
                  style: AppDesign.labelMedium.copyWith(
                    color: AppDesign.textSecondary,
                  ),
                ),
                StatusChip(text: booking.status, color: statusColor),
              ],
            ),
            const SizedBox(height: AppDesign.spaceM),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: booking.machineDetails?.image != null
                        ? DecorationImage(
                            image: NetworkImage(booking.machineDetails!.image!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: booking.machineDetails?.image == null
                      ? const Icon(Icons.agriculture, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: AppDesign.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.machineDetails?.name ?? 'Unknown Machine',
                        style: AppDesign.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy • hh:mm a',
                        ).format(booking.startTime),
                        style: AppDesign.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price: ₹${booking.totalPrice}',
                        style: AppDesign.titleMedium.copyWith(
                          color: AppDesign.booking,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isPending) ...[
              const SizedBox(height: AppDesign.spaceM),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _cancelBooking(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppDesign.error,
                    side: BorderSide(color: AppDesign.error),
                  ),
                  child: const Text('Cancel Booking'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
