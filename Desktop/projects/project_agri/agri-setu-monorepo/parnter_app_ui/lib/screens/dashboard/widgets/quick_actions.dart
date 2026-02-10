import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';
import '../../equipment/add_equipment_screen.dart';
import '../../bookings/bookings_screen.dart';
import '../../calendar/calendar_screen.dart';
import '../../profile/profile_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'Add Machine',
        'icon': Icons.add_circle_outline,
        'color': ProviderColors.accent,
        'route': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEquipmentScreen()),
          );
        },
      },
      {
        'title': 'My Calendar',
        'icon': Icons.calendar_month,
        'color': ProviderColors.secondary,
        'route': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalendarScreen()),
          );
        },
      },
      {
        'title': 'All Bookings',
        'icon': Icons.list_alt,
        'color': ProviderColors.primary,
        'route': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BookingsScreen()),
          );
        },
      },
      {
        'title': 'Performance',
        'icon': Icons.bar_chart,
        'color': Colors.purple,
        'route': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: action['route'] as VoidCallback,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  action['title'] as String,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: ProviderColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
