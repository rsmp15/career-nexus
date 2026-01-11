import 'package:flutter/material.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedGradientBackground extends StatelessWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base muted color
        Container(color: AppTheme.background),

        // Moving soft blobs
        Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 100,
                      color: AppTheme.primary.withOpacity(0.15),
                    ),
                  ],
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(begin: 0, end: 50, duration: 4.seconds)
            .scaleXY(begin: 1, end: 1.2, duration: 5.seconds),

        Positioned(
              bottom: -50,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondary.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 80,
                      color: AppTheme.secondary.withOpacity(0.1),
                    ),
                  ],
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveX(begin: 0, end: 30, duration: 6.seconds)
            .scaleXY(begin: 1, end: 1.1, duration: 7.seconds),

        // Glass overlay (optional, effectively just the content)
        Positioned.fill(child: child),
      ],
    );
  }
}
