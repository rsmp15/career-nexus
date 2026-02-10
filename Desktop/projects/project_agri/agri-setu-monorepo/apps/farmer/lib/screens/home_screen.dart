import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import 'package:agrisetu_ui/agrisetu_ui.dart';
import '../theme/app_design.dart';
import '../widgets/common/glass_card.dart';
import '../widgets/equipment_card.dart';
import 'equipment_detail_screen.dart';
import 'equipment_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Machine> _featuredMachines = [];
  bool _isLoading = true;
  final PageController _carouselController = PageController();
  int _currentCarouselPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedMachines();
  }

  Future<void> _fetchFeaturedMachines() async {
    try {
      final machines = await context.read<InventoryService>().getMachines(
        radius: 50000,
      ); // Fetch nearby
      if (mounted) {
        setState(() => _featuredMachines = machines.take(5).toList());
      }
    } catch (e) {
      debugPrint("Error fetching featured machines: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDesign.spaceM),

          // Ad Carousel (Featured Machines)
          _buildFeaturedCarousel(),

          const SizedBox(height: AppDesign.spaceXL),

          // Main Categories
          _buildMainCategories(),

          const SizedBox(height: AppDesign.spaceXL),

          // Nearby Equipment
          _buildNearbyEquipment(),
        ],
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_featuredMachines.isEmpty) {
      return Container(
        height: 160,
        margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
        decoration: BoxDecoration(
          color: AppDesign.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'No machines found nearby',
            style: TextStyle(color: AppDesign.textMuted),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) =>
                setState(() => _currentCarouselPage = index),
            itemCount: _featuredMachines.length,
            itemBuilder: (context, index) {
              final machine = _featuredMachines[index];
              return _buildFeaturedCard(machine);
            },
          ),
        ),
        const SizedBox(height: AppDesign.spaceM),
        // Carousel indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_featuredMachines.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentCarouselPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentCarouselPage == index
                    ? AppDesign.booking
                    : AppDesign.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Machine machine) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EquipmentDetailScreen(machine: machine),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: machine.image != null
              ? DecorationImage(
                  image: NetworkImage(machine.image!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                )
              : null,
          gradient: machine.image == null ? AppDesign.bookingGradient : null,
          boxShadow: [
            BoxShadow(
              color: AppDesign.booking.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (machine.image == null)
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.agriculture,
                  size: 120,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDesign.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    machine.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${machine.pricePerHour}/hr',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: AppDesign.booking,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCategories() {
    final categories = [
      {
        'icon': Icons.agriculture,
        'label': 'Equipment',
        'color': AppDesign.booking,
        'description': 'Rent tractors & more',
      },
      {
        'icon': Icons.storefront,
        'label': 'Shops',
        'color': AppDesign.social,
        'description': 'Find nearby stores',
      },
      {
        'icon': Icons.account_balance,
        'label': 'Govt Schemes',
        'color': AppDesign.warning,
        'description': 'Subsidies & benefits',
      },
      {
        'icon': Icons.support_agent,
        'label': 'Support',
        'color': AppDesign.success,
        'description': 'Get help & guidance',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(
              color: AppDesign.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDesign.spaceM),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppDesign.spaceM,
            mainAxisSpacing: AppDesign.spaceM,
            childAspectRatio: 1.4,
            children: categories.map((cat) {
              return GestureDetector(
                onTap: () {
                  if (cat['label'] == 'Equipment') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EquipmentListScreen(),
                      ),
                    );
                  }
                },
                child: GlassCard(
                  padding: const EdgeInsets.all(AppDesign.spaceM),
                  borderRadius: 16,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          cat['icon'] as IconData,
                          color: cat['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat['label'] as String,
                        style: const TextStyle(
                          color: AppDesign.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cat['description'] as String,
                        style: const TextStyle(
                          color: AppDesign.textMuted,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyEquipment() {
    if (_isLoading || _featuredMachines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nearby Equipment',
                style: TextStyle(
                  color: AppDesign.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EquipmentListScreen(),
                  ),
                ),
                child: Text(
                  'View All',
                  style: AppDesign.labelLarge.copyWith(
                    color: AppDesign.booking,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDesign.spaceM),
        ..._featuredMachines.map(
          (machine) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
            child: EquipmentCard(
              machine: machine,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EquipmentDetailScreen(machine: machine),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
