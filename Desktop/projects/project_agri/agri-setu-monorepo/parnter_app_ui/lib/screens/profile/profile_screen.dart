import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../earnings/earnings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: ProviderColors.primaryGradient,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 48,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: ProviderColors.softShadow,
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: ProviderColors.primaryLight,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // User info
            Text(
              'John Doe',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ProviderColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '+91 98765 43210',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: ProviderColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Stats row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: ProviderColors.softShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    icon: Icons.star,
                    value: '4.8',
                    label: 'Rating',
                    color: Colors.amber,
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  _StatItem(
                    icon: Icons.work,
                    value: '152',
                    label: 'Jobs',
                    color: ProviderColors.primary,
                  ),
                  Container(width: 1, height: 40, color: Colors.grey.shade200),
                  _StatItem(
                    icon: Icons.access_time,
                    value: '2y',
                    label: 'Experience',
                    color: ProviderColors.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuSection(
                    title: 'Account',
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        title: 'Personal Info',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.account_balance_wallet,
                        title: 'Earnings',
                        trailing: '₹45,000',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EarningsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Preferences',
                    items: [
                      _MenuItem(
                        icon: Icons.language,
                        title: 'Language',
                        trailing: 'English',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _MenuSection(
                    title: 'Support',
                    items: [
                      _MenuItem(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        textColor: ProviderColors.error,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: ProviderColors.textPrimary,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: ProviderColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ProviderColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: ProviderColors.softShadow,
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? textColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? ProviderColors.textPrimary;
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: color),
      ),
      trailing: trailing != null
          ? Text(
              trailing!,
              style: GoogleFonts.inter(
                color: ProviderColors.textSecondary,
                fontSize: 13,
              ),
            )
          : const Icon(
              Icons.chevron_right,
              color: ProviderColors.textMuted,
              size: 20,
            ),
    );
  }
}
