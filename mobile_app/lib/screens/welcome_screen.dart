import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/widgets/glass_container.dart';
import 'package:mobile_app/widgets/animated_background.dart';
import 'package:mobile_app/theme/app_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _showGoalSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppTheme.background.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Launch Your Journey",
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Select your primary motivation to begin the assessment.",
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 40),
                      _GoalGlassCard(
                        title: "Money",
                        icon: Icons.monetization_on_outlined,
                        description:
                            "Focus on financial freedom & wealth generation.",
                        iconColor: Colors.amber,
                        delay: 200,
                        onTap: () => _navigateToAssessment(context, "Money"),
                      ),
                      _GoalGlassCard(
                        title: "Power",
                        icon: Icons.gavel_outlined,
                        description: "Paths leading to influence & leadership.",
                        iconColor: Colors.redAccent,
                        delay: 400,
                        onTap: () => _navigateToAssessment(context, "Power"),
                      ),
                      _GoalGlassCard(
                        title: "Achievement",
                        icon: Icons.emoji_events_outlined,
                        description:
                            "Mastery, recognition, and skill excellence.",
                        iconColor: Colors.blueAccent,
                        delay: 600,
                        onTap: () =>
                            _navigateToAssessment(context, "Achievement"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedGradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroSection(context),
              _buildStatsRow(context),
              _buildFeatureCards(context),
              _buildDiscoverySection(context),
              _buildTechnicalInsights(context),
              _buildWhySection(context),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary,
                  AppTheme.primary.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 64),
          ).animate().scale(delay: 200.ms),
          const SizedBox(height: 32),
          Text(
            "Free AI  Assessment",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
            ),
          ).animate().fadeIn().slideY(begin: 0.3),
          const SizedBox(height: 16),
          Text(
            "Discover your unique  profile through our comprehensive psychological evaluation system. Get professional insights in just 15 minutes with our AI-powered analysis.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => _showGoalSelection(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text(
              "Start Your Free Assessment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatItem(Icons.star_outline, "100% Free"),
          _buildStatSeparator(),
          _buildStatItem(
            Icons.verified_user_outlined,
            "Scientifically Validated",
          ),
          // _buildStatSeparator(),
          // _buildStatItem(Icons.trending_up, "50,000+ Completed"),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatSeparator() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: Text("|", style: TextStyle(color: Colors.grey)),
  );

  Widget _buildFeatureCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              Icons.group_outlined,
              "Four Comprehensive Tests",
              "Big Five, MBTI, Word Association, and Situational Reaction.",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              Icons.auto_awesome_outlined,
              "AI-Powered Analysis",
              "Advanced algorithms provide detailed insights into your strengths.",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              Icons.timer_outlined,
              "Quick & Accurate",
              "Complete professional assessment in 15-20 minutes.",
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2);
  }

  Widget _buildInfoCard(IconData icon, String title, String desc) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverySection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const Text(
            "What You'll Discover About Yourself",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _buildDiscoveryItem(
                "Big Five  Traits (OCEAN)",
                "Measure Openness, Conscientiousness, Extraversion, etc.",
              ),
              _buildDiscoveryItem(
                "MBTI  Type",
                "Discover your Myers-Briggs type and psychological preferences.",
              ),
              _buildDiscoveryItem(
                "Cognitive Patterns (Word Association)",
                "Reveal emotional responses through rapid word tests.",
              ),
              _buildDiscoveryItem(
                "Decision-Making Style",
                "Assess your judgment under pressure via real-life scenarios.",
              ),
              _buildDiscoveryItem(
                "Personalized Growth Recommendations",
                "Tailored suggestions for career and personal development.",
              ),
              _buildDiscoveryItem(
                "Comprehensive  Report",
                "Detailed analysis with strengths and consistency insights.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryItem(String title, String desc) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalInsights(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Text(
            "Powered by Advanced AI",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Our system utilizes Google Gemini models integrated with industry-standard psychometric frameworks to deliver high-fidelity career mapping and  analysis.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Text(
            "Why Take Our Assessment?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWhyItem(
                Icons.psychology_outlined,
                "Self-Awareness",
                Colors.blue,
              ),
              _buildWhyItem(
                Icons.explore_outlined,
                "Career Guidance",
                Colors.green,
              ),
              _buildWhyItem(
                Icons.people_outlined,
                "Better Relationships",
                Colors.purple,
              ),
              _buildWhyItem(
                Icons.trending_up,
                "Personal Growth",
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhyItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _showGoalSelection(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text(
              "Start Your Free Assessment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "✓ Completely Free",
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              SizedBox(width: 12),
              Text(
                "✓ No Registration",
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              SizedBox(width: 12),
              Text(
                "✓ Privacy Protected",
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAssessment(BuildContext context, String goal) {
    Navigator.pushNamed(context, '/assessment', arguments: {'goal': goal});
  }
}

class _GoalGlassCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final Color iconColor;
  final int delay;
  final VoidCallback onTap;

  const _GoalGlassCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.iconColor,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GlassContainer(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.2),
    );
  }
}
