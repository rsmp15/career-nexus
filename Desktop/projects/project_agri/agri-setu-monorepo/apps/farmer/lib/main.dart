import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import 'providers/app_mode.dart';
import 'theme/app_design.dart';
import 'screens/login_screen.dart';

void main() {
  final apiClient = ApiClient(baseUrl: ApiConfig.baseUrl);
  final authService = AuthService(apiClient);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: apiClient),
        Provider.value(value: authService),
        Provider(create: (_) => InventoryService(apiClient)),
        Provider(create: (_) => BookingService(apiClient)),
        ChangeNotifierProvider(create: (_) => AppMode()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, apiClient)..init(),
        ),
      ],
      child: const FarmerApp(),
    ),
  );
}

class FarmerApp extends StatelessWidget {
  const FarmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppMode>(
      builder: (context, appMode, _) {
        return MaterialApp(
          title: 'AgriSetu Farmer',
          debugShowCheckedModeBanner: false,
          theme: AppDesign.theme(isBookingMode: appMode.isBookingMode),
          home: const LoginScreen(),
        );
      },
    );
  }
}
