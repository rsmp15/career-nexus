import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import '../../theme/provider_colors.dart';
import '../../widgets/premium_components.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<List<Booking>> _bookingsFuture;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _bookingsFuture = context.read<BookingService>().getBookings();
  }

  List<Booking> _getEventsForDay(DateTime day, List<Booking> bookings) {
    return bookings.where((booking) {
      // Create a range of dates for the booking duration
      final start = booking.startTime;
      // final end = booking.endTime; // Assuming endTime is available or calculated

      // If endTime is not available, we can approximate with duration
      final duration = booking.duration ?? 1;
      final calculatedEnd = start.add(Duration(days: duration));

      return day.isAfter(start.subtract(const Duration(days: 1))) &&
          day.isBefore(calculatedEnd.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: Text(
          'Schedule',
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
          final selectedEvents = _getEventsForDay(_selectedDay!, bookings);

          return Column(
            children: [
              GlassCard(
                margin: const EdgeInsets.all(20),
                child: TableCalendar<Booking>(
                  firstDay: DateTime.utc(2020, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() => _calendarFormat = format);
                    }
                  },
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  eventLoader: (day) => _getEventsForDay(day, bookings),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: ProviderColors.primary.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: ProviderColors.primary,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: ProviderColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Bookings for ${DateFormat('MMM dd').format(_selectedDay!)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ProviderColors.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: selectedEvents.isEmpty
                            ? Center(
                                child: Text(
                                  'No bookings for this day',
                                  style: GoogleFonts.inter(
                                    color: ProviderColors.textMuted,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                itemCount: selectedEvents.length,
                                itemBuilder: (context, index) {
                                  final booking = selectedEvents[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: ProviderColors.background,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: ProviderColors.secondary
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: ProviderColors.primary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.agriculture,
                                            color: ProviderColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                booking.machineDetails?.name ??
                                                    'Machine',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  color: ProviderColors
                                                      .textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${DateFormat('HH:mm').format(booking.startTime)} - ${booking.farmerName ?? "Customer"}',
                                                style: GoogleFonts.inter(
                                                  color: ProviderColors
                                                      .textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        StatusBadge(
                                          label: booking.status,
                                          color: booking.status == 'CONFIRMED'
                                              ? ProviderColors.accent
                                              : (booking.status == 'COMPLETED'
                                                    ? ProviderColors.success
                                                    : Colors.grey),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
