import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart'; // AuthService
import '../../theme/provider_colors.dart';
import '../../widgets/premium_components.dart';
import '../login_screen.dart';
import '../earnings/earnings_screen.dart'; // For navigation

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = context.read<AuthService>().getMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ProviderColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await context.read<AuthService>().logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        // Assuming getMe returns User or User?
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ProviderColors.secondary.withOpacity(0.2),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: ProviderColors.softShadow,
                      ),
                      child: Center(
                        child: Text(
                          (user?.username ?? 'P').substring(0, 1).toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: ProviderColors.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ProviderColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  user?.username ?? 'Partner Name',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ProviderColors.textPrimary,
                  ),
                ),
                Text(
                  user?.phoneNumber ?? '+91 98765 43210',
                  style: GoogleFonts.inter(
                    color: ProviderColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                StatusBadge(
                  label: 'Verified Partner',
                  color: ProviderColors.success,
                  isOutlined: true,
                ),

                const SizedBox(height: 32),

                // Menu Items
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: 'Edit Profile',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _ProfileMenuItem(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Payment Methods',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _ProfileMenuItem(
                        icon: Icons.history,
                        title: 'Transaction History',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EarningsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _ProfileMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.inter(
                    color: ProviderColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ProviderColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: ProviderColors.textSecondary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: ProviderColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: ProviderColors.textMuted,
        size: 20,
      ),
    );
  }
}
