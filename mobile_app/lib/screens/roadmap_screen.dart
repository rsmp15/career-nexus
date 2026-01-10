import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_app/theme/app_theme.dart';
import 'package:mobile_app/widgets/clay_container.dart';
import 'package:google_fonts/google_fonts.dart';

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  List<dynamic> selectedJobs = [];
  Map<String, String> roadmaps = {}; // onet_code -> markdown
  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
      selectedJobs = args;
      isInit = true;
      if (selectedJobs.isNotEmpty) {
        _fetchRoadmap(selectedJobs[0]['onet_code'], selectedJobs[0]['title']);
      }
    }
  }

  Future<void> _fetchRoadmap(String code, String title) async {
    if (roadmaps.containsKey(code)) return;

    try {
      final response = await http.post(
        Uri.parse('https://career-nexus-api.onrender.com/roadmap'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "onet_code": code,
          "title": title,
          "education_level": "Undergrad",
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          roadmaps[code] = data['roadmap'];
        });
      }
    } catch (e) {
      print("Error fetching roadmap: $e");
    }
  }

  double calculateSynergy() {
    if (selectedJobs.isEmpty) return 0.0;
    Set<String> prefixes = {};
    for (var job in selectedJobs) {
      String code = job['onet_code'].toString();
      if (code.length > 2) {
        prefixes.add(code.substring(0, 2));
      }
    }

    if (prefixes.length == 1) return 1.0;
    if (prefixes.length == 2) return 0.6;
    return 0.3;
  }

  @override
  Widget build(BuildContext context) {
    double synergy = calculateSynergy();
    Color synergyColor = synergy > 0.8
        ? Colors.green
        : (synergy > 0.5 ? Colors.amber : Colors.redAccent);
    String synergyText = synergy > 0.8
        ? "Highly Focused"
        : (synergy > 0.5 ? "Versatile Pair" : "Broad Interests");

    return DefaultTabController(
      length: selectedJobs.length,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text("Career Strategy"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primary,
            onTap: (index) {
              _fetchRoadmap(
                selectedJobs[index]['onet_code'],
                selectedJobs[index]['title'],
              );
            },
            tabs: selectedJobs
                .map(
                  (j) => Tab(
                    text: j['title'].toString().split(' ').take(2).join(' '),
                  ),
                )
                .toList(),
          ),
        ),
        body: Column(
          children: [
            // Synergy Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClayContainer(
                depth: 8,
                borderRadius: 20,
                color: synergyColor.withValues(alpha:0.1),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: synergyColor.withValues(alpha:0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.hub, color: synergyColor),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Strategy Score",
                          style: TextStyle(
                            color: synergyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          synergyText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ClayContainer(
                      depth: -3,
                      borderRadius: 12,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        "${(synergy * 10).toStringAsFixed(1)}/10",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: synergyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Roadmap Content
            Expanded(
              child: TabBarView(
                children: selectedJobs.map((job) {
                  String code = job['onet_code'];
                  String? content = roadmaps[code];

                  if (content == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClayContainer(
                      color: const Color(0xFFF8FAFC), // White paper-like
                      depth: 2,
                      borderRadius: 24,
                      child: Markdown(
                        data: content,
                        padding: const EdgeInsets.all(16),
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              h1: GoogleFonts.nunito(
                                color: AppTheme.primary,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                              h2: GoogleFonts.nunito(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              p: GoogleFonts.nunito(
                                fontSize: 16,
                                height: 1.6,
                                color: AppTheme.textSecondary,
                              ),
                              strong: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                              blockSpacing: 16.0,
                            ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
