import 'package:flutter/material.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/screens/welcome_screen.dart';
import 'package:mobile_app/screens/assessment_screen.dart';
import 'package:mobile_app/screens/results_screen.dart';
import 'package:mobile_app/screens/roadmap_screen.dart';
import 'package:mobile_app/screens/web_view_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }
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
        '/webview': (context) => const WebViewScreen(),
      },
    );
  }
}
