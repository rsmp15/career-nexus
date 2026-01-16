import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/widgets/glass_container.dart';
import 'package:mobile_app/widgets/animated_background.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SelfIntroScreen extends StatefulWidget {
  const SelfIntroScreen({super.key});

  @override
  State<SelfIntroScreen> createState() => _SelfIntroScreenState();
}

class _SelfIntroScreenState extends State<SelfIntroScreen> {
  final _nameController = TextEditingController();
  final _otherHobbyController = TextEditingController();
  final _otherGrowthAreaController = TextEditingController();
  String _selectedGoal = 'Achievement'; // Default goal
  final List<String> _selectedHobbies = [];
  final List<String> _selectedGrowthAreas = [];

  final List<String> _hobbiesOptions = [
    'Reading',
    'Coding',
    'Gaming',
    'Music',
    'Sports',
    'Art',
    'Traveling',
    'Cooking',
    'Photography',
    'Writing',
    'Gardening',
    'Fitness',
    'Dancing',
    'Meditation',
    'Podcasting',
    'Volunteer Work',
    'Other',
  ];

  final List<String> _growthAreasOptions = [
    'Public Speaking',
    'Time Management',
    'Networking',
    'Technical Skills',
    'Leadership',
    'Emotional Intelligence',
    'Decision Making',
    'Problem Solving',
    'Adaptability',
    'Project Management',
    'Conflict Resolution',
    'Attention to Detail',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _otherHobbyController.dispose();
    _otherGrowthAreaController.dispose();
    super.dispose();
  }

  void _onHobbyToggle(String hobby) {
    setState(() {
      if (_selectedHobbies.contains(hobby)) {
        _selectedHobbies.remove(hobby);
      } else {
        _selectedHobbies.add(hobby);
      }
    });
  }

  void _onGrowthAreaToggle(String area) {
    setState(() {
      if (_selectedGrowthAreas.contains(area)) {
        _selectedGrowthAreas.remove(area);
      } else {
        _selectedGrowthAreas.add(area);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Let's get to know you",
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ).animate().fadeIn().slideX(begin: -0.2),
                const SizedBox(height: 8),
                Text(
                  "Help us personalize your career journey analysis.",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 40),

                _buildInputField(
                  label: "What's your name?",
                  controller: _nameController,
                  hint: "Enter your full name",
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),

                const SizedBox(height: 32),
                _buildSectionTitle(
                  "What are your hobbies?",
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),
                _buildChipsSelector(
                  options: _hobbiesOptions,
                  selectedItems: _selectedHobbies,
                  onToggle: _onHobbyToggle,
                ).animate().fadeIn(delay: 600.ms),
                if (_selectedHobbies.contains('Other'))
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildInputField(
                      label: "Please specify your other hobby",
                      controller: _otherHobbyController,
                      hint: "Enter hobby",
                    ).animate().fadeIn().slideY(begin: 0.1),
                  ),

                const SizedBox(height: 32),
                _buildSectionTitle(
                  "Areas for growth (Threats/Weaknesses)",
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 16),
                _buildChipsSelector(
                  options: _growthAreasOptions,
                  selectedItems: _selectedGrowthAreas,
                  onToggle: _onGrowthAreaToggle,
                ).animate().fadeIn(delay: 800.ms),
                if (_selectedGrowthAreas.contains('Other'))
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: _buildInputField(
                      label: "Please specify your other area for growth",
                      controller: _otherGrowthAreaController,
                      hint: "Enter growth area",
                    ).animate().fadeIn().slideY(begin: 0.1),
                  ),

                const SizedBox(height: 32),
                _buildSectionTitle(
                  "What is your primary motivation?",
                ).animate().fadeIn(delay: 1000.ms),
                const SizedBox(height: 16),
                _buildMotivationSelector().animate().fadeIn(delay: 1000.ms),

                const SizedBox(height: 48),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your name'),
                          ),
                        );
                        return;
                      }

                      final hobbies = List<String>.from(_selectedHobbies);
                      if (hobbies.contains('Other') &&
                          _otherHobbyController.text.isNotEmpty) {
                        hobbies.remove('Other');
                        hobbies.add(_otherHobbyController.text);
                      }

                      final growthAreas = List<String>.from(
                        _selectedGrowthAreas,
                      );
                      if (growthAreas.contains('Other') &&
                          _otherGrowthAreaController.text.isNotEmpty) {
                        growthAreas.remove('Other');
                        growthAreas.add(_otherGrowthAreaController.text);
                      }

                      Navigator.pushNamed(
                        context,
                        '/assessment',
                        arguments: {
                          'name': _nameController.text,
                          'hobbies': hobbies,
                          'growthAreas': growthAreas,
                          'goal': _selectedGoal,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 64,
                        vertical: 20,
                      ),
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      "Continue to Assessment",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).animate().scale(delay: 1.seconds),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        const SizedBox(height: 12),
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          borderRadius: BorderRadius.circular(16),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: AppTheme.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipsSelector({
    required List<String> options,
    required List<String> selectedItems,
    required Function(String) onToggle,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = selectedItems.contains(option);
        return GestureDetector(
          onTap: () => onToggle(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.textSecondary.withValues(alpha: 0.2),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  Widget _buildMotivationSelector() {
    final List<Map<String, dynamic>> motivations = [
      {
        'title': 'Money',
        'icon': Icons.monetization_on_outlined,
        'color': Colors.amber,
      },
      {
        'title': 'Power',
        'icon': Icons.gavel_outlined,
        'color': Colors.redAccent,
      },
      {
        'title': 'Achievement',
        'icon': Icons.emoji_events_outlined,
        'color': Colors.blueAccent,
      },
    ];

    return Row(
      children: motivations.map((m) {
        final isSelected = _selectedGoal == m['title'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedGoal = m['title']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: isSelected
                    ? m['color'].withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? m['color']
                      : AppTheme.textSecondary.withValues(alpha: 0.1),
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: m['color'].withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(
                    m['icon'],
                    color: isSelected ? m['color'] : AppTheme.textSecondary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    m['title'],
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
