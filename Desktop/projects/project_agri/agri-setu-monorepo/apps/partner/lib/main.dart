import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import 'package:agrisetu_ui/agrisetu_ui.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PartnerApp());
}

class PartnerApp extends StatelessWidget {
  const PartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(
      baseUrl: ApiConfig.baseUrl,
    ); // Android Emulator localhost
    final authService = AuthService(apiClient);

    return MultiProvider(
      providers: [
        Provider.value(value: apiClient),
        Provider.value(value: authService),
        Provider(create: (_) => InventoryService(apiClient)),
        Provider(create: (_) => BookingService(apiClient)),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, apiClient)..init(),
        ),
      ],
      child: MaterialApp(
        title: 'AgriSetu Partner',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
