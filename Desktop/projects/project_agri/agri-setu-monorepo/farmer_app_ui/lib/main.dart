import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/design_system.dart';
import 'core/app_mode.dart';
import 'screens/booking_home_screen.dart';
import 'screens/social_home_screen.dart';

void main() {
  runApp(const FarmerApp());
}

class FarmerApp extends StatelessWidget {
  const FarmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppMode(),
      child: Consumer<AppMode>(
        builder: (context, appMode, _) {
          return MaterialApp(
            title: 'AgriSetu - Farmer App',
            debugShowCheckedModeBanner: false,
            theme: AppDesign.theme(isBookingMode: appMode.isBookingMode),
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: Offset(appMode.isBookingMode ? -0.1 : 0.1, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  ),
                );
              },
              child: appMode.isBookingMode
                  ? const BookingHomeScreen(key: ValueKey('booking'))
                  : const SocialHomeScreen(key: ValueKey('social')),
            ),
          );
        },
      ),
    );
  }
}
