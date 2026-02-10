import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/colors.dart';
import '../../widgets/premium_components.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: ProviderColors.background,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: ProviderColors.softShadow,
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() => _calendarFormat = format);
                }
              },
              onPageChanged: (focusedDay) => _focusedDay = focusedDay,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ProviderColors.primary,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: ProviderColors.primary,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: ProviderColors.primary,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  gradient: ProviderColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: ProviderColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: ProviderColors.accent,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: ProviderColors.error),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: _selectedDay != null
                        ? 'Bookings for ${_selectedDay!.day}/${_selectedDay!.month}'
                        : 'Select a Date',
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _selectedDay == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 48,
                                  color: ProviderColors.textMuted,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Tap a date to view bookings',
                                  style: GoogleFonts.inter(
                                    color: ProviderColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: ProviderColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: ProviderColors.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'John Deere 5050D',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '09:00 AM - 05:00 PM',
                                            style: GoogleFonts.inter(
                                              color:
                                                  ProviderColors.textSecondary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StatusBadge(
                                      label: 'Confirmed',
                                      color: ProviderColors.success,
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
      ),
    );
  }
}
