import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_design.dart';
import '../providers/app_mode.dart';
import '../widgets/common/glass_icon_button.dart';
import 'home_screen.dart';
import 'equipment_list_screen.dart';
import 'bookings/bookings_screen.dart';
// import 'community_screen.dart'; // Future integration

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final appMode = Provider.of<AppMode>(context);

    // If Social Mode, we might want to show a completely different screen
    // For now, let's just keep the shell and maybe swap content
    // But since the task is specific to Booking UI sync, let's focus on that.

    return Scaffold(
      backgroundColor: AppDesign.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, appMode),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const EquipmentListScreen();
      case 2:
        return const BookingsScreen();
      case 3:
        return _buildPlaceholder('Chat');
      case 4:
        return _buildPlaceholder('Profile');
      default:
        return const HomeScreen();
    }
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 48, color: AppDesign.booking),
          const SizedBox(height: 16),
          Text(title, style: AppDesign.headlineMedium),
          const SizedBox(height: 8),
          Text('Coming Soon', style: AppDesign.caption),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppMode appMode) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceL,
        vertical: AppDesign.spaceM,
      ),
      child: Row(
        children: [
          // Profile avatar
          GestureDetector(
            onTap: () => setState(() => _currentNavIndex = 4),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppDesign.booking, width: 2),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://i.pravatar.cc/150?img=11',
                  ), // Placeholder avatar
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDesign.spaceM),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: AppDesign.caption.copyWith(color: AppDesign.textMuted),
                ),
                const Text(
                  'Kishan Kumar', // Placeholder Name
                  style: TextStyle(
                    color: AppDesign.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Switch to Social Mode
          _buildModeSwitch(context, appMode),

          const SizedBox(width: AppDesign.spaceS),

          // Notifications
          GlassIconButton(
            icon: Icons.notifications_outlined,
            onTap: () {},
            hasBadge: true,
          ),
        ],
      ),
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildModeSwitch(BuildContext context, AppMode appMode) {
    return GestureDetector(
      onTap: () {
        appMode.toggleMode();
        // Since we don't have Social Screen yet, maybe show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appMode.isBookingMode
                  ? 'Switched to Booking Mode'
                  : 'Switched to Social Mode (Coming Soon)',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
        // Revert ensuring we stay on booking for now if social is empty
        if (!appMode.isBookingMode) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => appMode.setBookingMode(),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppDesign.social.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppDesign.social.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people_alt_rounded,
              size: 18,
              color: AppDesign.social,
            ),
            const SizedBox(width: 6),
            Text(
              'Social',
              style: AppDesign.labelMedium.copyWith(
                color: AppDesign.social,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {
        'icon': Icons.home_rounded,
        'activeIcon': Icons.home_rounded,
        'label': 'Home',
      },
      {
        'icon': Icons.explore_outlined,
        'activeIcon': Icons.explore,
        'label': 'Explore',
      },
      {
        'icon': Icons.calendar_today_outlined,
        'activeIcon': Icons.calendar_today,
        'label': 'Bookings',
      },
      {
        'icon': Icons.chat_bubble_outline,
        'activeIcon': Icons.chat_bubble,
        'label': 'Chat',
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Profile',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppDesign.surface,
        border: Border(top: BorderSide(color: AppDesign.divider)),
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = _currentNavIndex == index;
              final item = items[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentNavIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.all(isActive ? 10 : 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppDesign.booking.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isActive
                              ? (item['activeIcon'] as IconData)
                              : (item['icon'] as IconData),
                          color: isActive
                              ? AppDesign.booking
                              : AppDesign.textMuted,
                          size: 24,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(height: 4),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            color: AppDesign.booking,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
