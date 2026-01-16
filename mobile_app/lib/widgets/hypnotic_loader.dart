import 'package:flutter/material.dart';
import 'package:mobile_app/theme/app_theme.dart';
import 'dart:ui' show lerpDouble;

class HypnoticLoader extends StatelessWidget {
  const HypnoticLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final demoData = [
      {
        'title': 'AI Analysis',
        'subtitle': 'Analyzing your profile markers...',
        'icon': Icons.search,
      },
      {
        'title': 'Career Strategy',
        'subtitle': 'Mapping your educational path...',
        'icon': Icons.menu_book,
      },
      {
        'title': 'Market Match',
        'subtitle': 'Finding high-demand opportunities...',
        'icon': Icons.work,
      },
      {
        'title': 'Future Growth',
        'subtitle': 'Projecting your career trajectory...',
        'icon': Icons.trending_up,
      },
      {
        'title': 'Skill Alignment',
        'subtitle': 'Verifying competence overlaps...',
        'icon': Icons.school,
      },
      {
        'title': 'Finalizing Results',
        'subtitle': 'Preparing your custom roadmap...',
        'icon': Icons.stars,
      },
    ];

    return HypnoticCarousel(
      itemCount: demoData.length,
      cardWidth: 280,
      cardHeight: 320,
      duration: const Duration(seconds: 15),
      itemBuilder: (context, index, normalizedDistance) {
        final data = demoData[index];
        final absDist = normalizedDistance.abs();
        final contentOpacity = (1.0 - (absDist / 0.25)).clamp(0.0, 1.0);

        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.1 * contentOpacity),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Content (Only visible when near center)
              Opacity(
                opacity: contentOpacity,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          data['icon'] as IconData,
                          color: AppTheme.primary,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        data['title'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data['subtitle'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef ItemBuilder =
    Widget Function(BuildContext context, int index, double normalizedDistance);

class HypnoticCarousel extends StatefulWidget {
  final int itemCount;
  final ItemBuilder itemBuilder;
  final Duration duration;
  final double cardWidth;
  final double cardHeight;

  const HypnoticCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.duration = const Duration(seconds: 10),
    this.cardWidth = 200,
    this.cardHeight = 300,
  });

  @override
  State<HypnoticCarousel> createState() => _HypnoticCarouselState();
}

class _HypnoticCarouselState extends State<HypnoticCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final centerX = screenWidth / 2;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Total width calculations
            // Negative spacing for overlap as requested
            const spacing = -120.0;
            final totalItemWidth = widget.cardWidth + spacing;
            final totalWidth = widget.itemCount * totalItemWidth;

            // Generate card data and sort by proximity to center for correct z-index
            final cardData = List.generate(widget.itemCount, (index) {
              double offset =
                  (index * totalItemWidth) - (_controller.value * totalWidth);
              double relativeOffset = offset % totalWidth;
              double xPos = (relativeOffset - totalWidth / 2);
              double screenX = centerX + xPos - (widget.cardWidth / 2);

              // Normalize distance: 0 is center, 1 is approx 2 items away
              double normalizedDistance = (xPos / (totalItemWidth * 2)).clamp(
                -1.0,
                1.0,
              );
              double absDist = normalizedDistance.abs();

              double scale;
              double opacity;

              if (absDist <= 0.5) {
                double t = absDist / 0.5;
                double easedT = Curves.easeInOut.transform(t);
                scale = lerpDouble(1.0, 0.75, easedT)!;
                opacity = lerpDouble(1.0, 0.6, easedT)!;
              } else {
                double t = (absDist - 0.5) / 0.5;
                double easedT = Curves.easeInOut.transform(t);
                scale = lerpDouble(0.75, 0.5, easedT)!;
                opacity = lerpDouble(0.6, 0.3, easedT)!;
              }

              return (
                index: index,
                screenX: screenX,
                scale: scale,
                opacity: opacity,
                normalizedDistance: normalizedDistance,
                // Higher depth value means further from center
                depth: absDist,
              );
            });

            // Sort by depth so center-most items are drawn last (on top)
            cardData.sort((a, b) => b.depth.compareTo(a.depth));

            return Stack(
              clipBehavior: Clip.none,
              children: cardData.map((data) {
                return Positioned(
                  left: data.screenX,
                  top: (constraints.maxHeight - widget.cardHeight) / 2,
                  child: Opacity(
                    opacity: data.opacity,
                    child: Transform.scale(
                      scale: data.scale,
                      child: SizedBox(
                        width: widget.cardWidth,
                        height: widget.cardHeight,
                        child: widget.itemBuilder(
                          context,
                          data.index,
                          data.normalizedDistance,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
