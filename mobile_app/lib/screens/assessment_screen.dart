import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:mobile_app/widgets/glass_container.dart';
import 'package:mobile_app/widgets/animated_background.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data State
  String lifeGoal = "";
  String educationLevel = "Undergrad";
  String mbtiCode = "";
  String riasecCode = "";

  // Cognitive
  final TextEditingController _reactionController = TextEditingController();
  final TextEditingController _numberMemController = TextEditingController();
  final TextEditingController _verbalMemController = TextEditingController();
  final TextEditingController _mbtiController = TextEditingController();
  final TextEditingController _riasecController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args['goal'] != null) {
      lifeGoal = args['goal'];
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submit() {
    Navigator.pushNamed(
      context,
      '/results',
      arguments: {
        "life_goal": lifeGoal,
        "mbti_code": _mbtiController.text,
        "riasec_code": _riasecController.text,
        "education_level": educationLevel,
        "domain_interest": _domainController.text,
        "cognitive_scores": {
          "reaction_time": int.tryParse(_reactionController.text) ?? 300,
          "number_memory": int.tryParse(_numberMemController.text) ?? 5,
          "verbal_memory": int.tryParse(_verbalMemController.text) ?? 30,
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Your Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedGradientBackground(
        child: Column(
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassContainer(
                opacity: 0.1,
                padding: const EdgeInsets.all(4),
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / 4,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                children: [
                  _buildStep(
                    title: "Current Status",
                    desc: "Where are you in your journey?",
                    child: Column(
                      children: [
                        _GlassSelectionButton(
                          label: "10th Passed",
                          isSelected: educationLevel == "10th",
                          onTap: () => setState(() => educationLevel = "10th"),
                        ),
                        _GlassSelectionButton(
                          label: "12th Passed",
                          isSelected: educationLevel == "12th",
                          onTap: () => setState(() => educationLevel = "12th"),
                        ),
                        _GlassSelectionButton(
                          label: "Undergraduate",
                          isSelected: educationLevel == "Undergrad",
                          onTap: () =>
                              setState(() => educationLevel = "Undergrad"),
                        ),
                        if (educationLevel == "Undergrad")
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: _GlassInput(
                              controller: _domainController,
                              label: "Domain Interest (e.g. CS)",
                              hint: "What are you studying?",
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildStep(
                    title: "Personality Type",
                    desc: "Enter your 4-letter MBTI code (e.g. INTJ).",
                    child: _GlassInput(
                      controller: _mbtiController,
                      label: "MBTI Code",
                      hint: "e.g. INTJ",
                      icon: Icons.psychology,
                    ),
                  ),
                  _buildStep(
                    title: "Career Aptitude",
                    desc: "Enter your RIASEC code (e.g. RIC).",
                    child: _GlassInput(
                      controller: _riasecController,
                      label: "RIASEC Code",
                      hint: "e.g. RIC (Realistic, Investigative...)",
                      icon: Icons.build,
                    ),
                  ),
                  _buildStep(
                    title: "Cognitive Stats",
                    desc: "Scores from HumanBenchmark.com",
                    child: Column(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/webview',
                              arguments: {'url': 'https://humanbenchmark.com'},
                            );
                          },
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text(
                            "Don't know your scores? Take the test",
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.secondary,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _GlassInput(
                          label: "Reaction Time (ms)",
                          controller: _reactionController,
                          isNumber: true,
                        ),
                        const SizedBox(height: 16),
                        _GlassInput(
                          label: "Number Memory (digits)",
                          controller: _numberMemController,
                          isNumber: true,
                        ),
                        const SizedBox(height: 16),
                        _GlassInput(
                          label: "Verbal Memory (score)",
                          controller: _verbalMemController,
                          isNumber: true,
                        ),
                      ],
                    ),
                    isLast: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: 300.ms,
                          curve: Curves.ease,
                        );
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                          color: AppTheme.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    )
                  else
                    const SizedBox(),

                  ElevatedButton(
                    onPressed: _currentPage == 3 ? _submit : _nextPage,
                    child: Text(_currentPage == 3 ? "Find Careers" : "Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String desc,
    required Widget child,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            desc,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 32),
          child,
        ],
      ).animate().fadeIn().slideX(),
    );
  }
}

class _GlassSelectionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GlassSelectionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        onTap: onTap,
        opacity: isSelected ? 0.3 : 0.1,
        color: isSelected ? AppTheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppTheme.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController controller;
  final bool isNumber;

  const _GlassInput({
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.15,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: AppTheme.primary) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}
