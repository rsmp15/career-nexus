import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/widgets/clay_container.dart';
import 'package:mobile_app/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              ClayContainer(
                depth: 8,
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CareerNexus",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Discover your future path in a friendly way.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.3, duration: 600.ms),
              const SizedBox(height: 40),
              Text(
                "What drives you?",
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _GoalClayCard(
                      title: "Money",
                      icon: Icons.monetization_on_outlined,
                      description: "Financial freedom & wealth.",
                      baseColor: const Color(0xFFFFF7ED), // Orange tint
                      iconColor: Colors.amber,
                      delay: 400,
                      onTap: () => _navigateToAssessment(context, "Money"),
                    ),
                    _GoalClayCard(
                      title: "Power",
                      icon: Icons.gavel_outlined,
                      description: "Influence & Leadership.",
                      baseColor: const Color(0xFFFEF2F2), // Red tint
                      iconColor: Colors.redAccent,
                      delay: 600,
                      onTap: () => _navigateToAssessment(context, "Power"),
                    ),
                    _GoalClayCard(
                      title: "Achievement",
                      icon: Icons.emoji_events_outlined,
                      description: "Mastery & Recognition.",
                      baseColor: const Color(0xFFEFF6FF), // Blue tint
                      iconColor: Colors.blueAccent,
                      delay: 800,
                      onTap: () =>
                          _navigateToAssessment(context, "Achievement"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAssessment(BuildContext context, String goal) {
    Navigator.pushNamed(context, '/assessment', arguments: {'goal': goal});
  }
}

class _GoalClayCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final Color baseColor;
  final Color iconColor;
  final int delay;
  final VoidCallback onTap;

  const _GoalClayCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.baseColor,
    required this.iconColor,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ClayContainer(
        onTap: onTap,
        color: baseColor,
        borderRadius: 24,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
          ],
        ),
      ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.2),
    );
  }
}
