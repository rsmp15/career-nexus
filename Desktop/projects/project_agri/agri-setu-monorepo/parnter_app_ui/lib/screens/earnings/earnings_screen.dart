import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../widgets/premium_components.dart';
import '../dashboard/widgets/earnings_chart.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: ProviderColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: ProviderColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: ProviderColors.primaryShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Total Balance',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹ 45,250',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BalanceStat(label: 'This Month', value: '₹12,500'),
                      Container(width: 1, height: 40, color: Colors.white24),
                      _BalanceStat(label: 'Pending', value: '₹3,200'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Analytics Chart
            const SectionHeader(title: 'Weekly Analytics'),
            const SizedBox(height: 12),
            GlassCard(
              child: SizedBox(height: 200, child: const EarningsChart()),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            const SectionHeader(title: 'Recent Transactions'),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final isCredit = index % 2 == 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: ProviderColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isCredit
                              ? ProviderColors.success.withValues(alpha: 0.1)
                              : ProviderColors.warning.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.access_time,
                          color: isCredit
                              ? ProviderColors.success
                              : ProviderColors.warning,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking #${10023 + index}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              isCredit ? 'Payment Received' : 'Pending',
                              style: GoogleFonts.inter(
                                color: ProviderColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isCredit ? "+" : ""}₹2,500',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isCredit
                                  ? ProviderColors.success
                                  : ProviderColors.warning,
                            ),
                          ),
                          Text(
                            'Today, ${10 + index}:30 AM',
                            style: GoogleFonts.inter(
                              color: ProviderColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label;
  final String value;

  const _BalanceStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
