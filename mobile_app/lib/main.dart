import 'package:flutter/material.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:mobile_app/screens/welcome_screen.dart';
import 'package:mobile_app/screens/assessment_screen.dart';
import 'package:mobile_app/screens/results_screen.dart';
import 'package:mobile_app/screens/roadmap_screen.dart';

void main() {
  runApp(const CareerNexusApp());
}

class CareerNexusApp extends StatelessWidget {
  const CareerNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareerNexus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/assessment': (context) => const AssessmentScreen(),
        '/results': (context) => const ResultsScreen(),
        '/roadmap_generation': (context) => const RoadmapScreen(),
      },
    );
  }
}
