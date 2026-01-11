import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:mobile_app/widgets/clay_container.dart';
import 'package:mobile_app/widgets/animated_background.dart';

import '../config.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<dynamic> jobs = [];
  bool isLoading = true;
  String error = "";

  // Selection
  final Set<String> selectedJobCodes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (jobs.isEmpty && isLoading) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      _fetchRecommendations(args);
    }
  }

  Future<void> _fetchRecommendations(Map args) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/recommend'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(args),
      );

      if (response.statusCode == 200) {
        setState(() {
          jobs = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Server Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error =
            "Failed to connect to AI Core. Make sure Backend is running.\n$e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Allow animated background to show
      extendBodyBehindAppBar: true,
      body: AnimatedGradientBackground(
        child: Column(
          children: [
            // Custom AppBar Area to handle SafeArea
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Matches",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    ClayContainer(
                      depth: 5,
                      borderRadius: 12,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: selectedJobCodes.length == 3
                          ? AppTheme.secondary.withValues(alpha: 0.2)
                          : AppTheme.surface,
                      child: Text(
                        "${selectedJobCodes.length}/3 Picked",
                        style: TextStyle(
                          color: selectedJobCodes.length == 3
                              ? AppTheme.secondary
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error.isNotEmpty
                  ? Center(child: Text(error, textAlign: TextAlign.center))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Text(
                            "We found these perfect fits for you.",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80, top: 0),
                            itemCount: jobs.length,
                            itemBuilder: (context, index) {
                              final job = jobs[index];
                              final isSelected = selectedJobCodes.contains(
                                job['onet_code'],
                              );

                              return _JobClayCard(
                                    job: job,
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedJobCodes.remove(
                                            job['onet_code'],
                                          );
                                        } else {
                                          if (selectedJobCodes.length < 3) {
                                            selectedJobCodes.add(
                                              job['onet_code'],
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Select only 3 top choices!",
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      });
                                    },
                                  )
                                  .animate()
                                  .fadeIn(delay: (index * 100).ms)
                                  .slideX(
                                    begin: 0.2,
                                    end: 0,
                                    curve: Curves.easeOutQuad,
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: selectedJobCodes.length == 3
          ? FloatingActionButton.extended(
              onPressed: () {
                final selectedJobs = jobs
                    .where((j) => selectedJobCodes.contains(j['onet_code']))
                    .toList();
                Navigator.pushNamed(
                  context,
                  '/roadmap_generation',
                  arguments: selectedJobs,
                );
              },
              label: const Text("Generate Roadmap"),
              icon: const Icon(Icons.auto_awesome),
              backgroundColor: AppTheme.secondary,
            )
          : null,
    );
  }
}

class _JobClayCard extends StatelessWidget {
  final dynamic job;
  final bool isSelected;
  final VoidCallback onTap;

  const _JobClayCard({
    required this.job,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double matchScore = job['match_score'];
    double percent = (matchScore / 15.0).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayContainer(
        onTap: onTap,
        color: isSelected
            ? AppTheme.primary.withValues(alpha: 0.05)
            : AppTheme.surface,
        depth: isSelected ? -5 : 8, // Pressed vs Floating effect
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job['title'],
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.primary,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearPercentIndicator(
                lineHeight: 8.0,
                percent: percent,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                progressColor: AppTheme.secondary,
                padding: EdgeInsets.zero,
                barRadius: const Radius.circular(4),
                animation: true,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              job['description'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: (job['reasoning'] as List)
                  .map<Widget>(
                    (r) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        r,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
