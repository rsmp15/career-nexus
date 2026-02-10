import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/provider_colors.dart';
import '../../widgets/premium_components.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ProviderColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: ProviderColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: ProviderColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: ProviderColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ProviderColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chat with farmers directly from the app',
              style: GoogleFonts.inter(
                color: ProviderColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(text: 'Notify Me', onPressed: () {}, width: 200),
          ],
        ),
      ),
    );
  }
}
