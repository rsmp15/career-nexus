import 'package:flutter/material.dart';
import '../../core/design_system.dart';
import '../../data/booking_data.dart';
import 'equipment_detail_screen.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  bool _isMapView = false;

  List<Equipment> get _filteredEquipment {
    return MockData.equipment.where((eq) {
      final matchesCategory =
          _selectedCategory == 'all' || eq.category == _selectedCategory;
      final matchesSearch =
          _searchController.text.isEmpty ||
          eq.name.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.background,
      body: SafeArea(
        child: Column(
          children: [
            // ════════════════════════════════════════════════════════════════
            // HEADER
            // ════════════════════════════════════════════════════════════════
            Padding(
              padding: const EdgeInsets.all(AppDesign.spaceL),
              child: Column(
                children: [
                  // Top row
                  Row(
                    children: [
                      GlassIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: AppDesign.spaceM),
                      Expanded(
                        child: Text(
                          'Equipment',
                          style: AppDesign.headlineMedium,
                        ),
                      ),
                      GlassIconButton(
                        icon: _isMapView ? Icons.view_list : Icons.map_outlined,
                        onTap: () => setState(() => _isMapView = !_isMapView),
                        iconColor: AppDesign.booking,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDesign.spaceM),

                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDesign.spaceM,
                    ),
                    decoration: BoxDecoration(
                      color: AppDesign.card,
                      borderRadius: BorderRadius.circular(AppDesign.radiusM),
                      border: Border.all(color: AppDesign.divider),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: AppDesign.textMuted),
                        const SizedBox(width: AppDesign.spaceM),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            style: AppDesign.bodyMedium.copyWith(
                              color: AppDesign.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search equipment...',
                              hintStyle: AppDesign.bodyMedium,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.close,
                              color: AppDesign.textMuted,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ════════════════════════════════════════════════════════════════
            // CATEGORY CHIPS
            // ════════════════════════════════════════════════════════════════
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceL,
                ),
                itemCount: MockData.categories.length,
                itemBuilder: (context, index) {
                  final cat = MockData.categories[index];
                  final isSelected = _selectedCategory == cat.id;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: AppDesign.spaceS),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? AppDesign.bookingAccentGradient
                            : null,
                        color: isSelected ? null : AppDesign.card,
                        borderRadius: BorderRadius.circular(
                          AppDesign.radiusFull,
                        ),
                        border: isSelected
                            ? null
                            : Border.all(color: AppDesign.divider),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            cat.icon,
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : AppDesign.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cat.name,
                            style: AppDesign.labelMedium.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppDesign.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppDesign.spaceL),

            // ════════════════════════════════════════════════════════════════
            // RESULTS
            // ════════════════════════════════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
              child: Row(
                children: [
                  Text(
                    '${_filteredEquipment.length} results',
                    style: AppDesign.labelMedium,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(
                          Icons.sort,
                          size: 16,
                          color: AppDesign.booking,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Sort by',
                          style: AppDesign.labelMedium.copyWith(
                            color: AppDesign.booking,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDesign.spaceM),

            // ════════════════════════════════════════════════════════════════
            // EQUIPMENT LIST
            // ════════════════════════════════════════════════════════════════
            Expanded(child: _isMapView ? _buildMapView() : _buildListView()),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
      itemCount: _filteredEquipment.length,
      itemBuilder: (context, index) {
        final eq = _filteredEquipment[index];
        return _buildEquipmentListItem(eq);
      },
    );
  }

  Widget _buildEquipmentListItem(Equipment eq) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EquipmentDetailScreen(equipment: eq),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDesign.spaceM),
        decoration: BoxDecoration(
          color: AppDesign.card,
          borderRadius: BorderRadius.circular(AppDesign.radiusL),
          border: Border.all(color: AppDesign.divider),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppDesign.radiusL),
              ),
              child: Image.network(
                eq.imageUrl,
                width: 120,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDesign.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(eq.name, style: AppDesign.titleMedium),
                        ),
                        StatusChip(
                          text: eq.isAvailable ? 'Available' : 'Booked',
                          color: eq.isAvailable
                              ? AppDesign.success
                              : AppDesign.error,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppDesign.booking.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            eq.categoryLabel,
                            style: AppDesign.caption.copyWith(
                              color: AppDesign.booking,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppDesign.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text('${eq.distance} km', style: AppDesign.caption),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppDesign.bookingAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${eq.rating} (${eq.reviews})',
                              style: AppDesign.caption.copyWith(
                                color: AppDesign.bookingAccent,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GradientText(
                              text: '₹${eq.pricePerHour.toInt()}',
                              style: AppDesign.titleMedium,
                              gradient: AppDesign.bookingAccentGradient,
                            ),
                            Text('/hr', style: AppDesign.caption),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        // Map placeholder with gradient overlay
        Container(
          decoration: BoxDecoration(
            color: AppDesign.cardLight,
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800',
              ),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
        ),

        // Map pins
        ...List.generate(_filteredEquipment.length, (index) {
          final eq = _filteredEquipment[index];
          final top = 80.0 + (index * 60) % 250;
          final left =
              40.0 + (index * 80) % (MediaQuery.of(context).size.width - 150);

          return Positioned(
            top: top,
            left: left,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EquipmentDetailScreen(equipment: eq),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: eq.isAvailable
                          ? AppDesign.bookingAccentGradient
                          : const LinearGradient(
                              colors: [AppDesign.card, AppDesign.card],
                            ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: AppDesign.cardShadow,
                    ),
                    child: Text(
                      '₹${eq.pricePerHour.toInt()}',
                      style: AppDesign.labelLarge.copyWith(
                        color: eq.isAvailable
                            ? Colors.white
                            : AppDesign.textMuted,
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 10,
                    color: eq.isAvailable
                        ? AppDesign.booking
                        : AppDesign.textMuted,
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: eq.isAvailable
                          ? AppDesign.booking
                          : AppDesign.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        // Bottom preview card
        Positioned(
          bottom: AppDesign.spaceL,
          left: AppDesign.spaceL,
          right: AppDesign.spaceL,
          child: Container(
            padding: const EdgeInsets.all(AppDesign.spaceM),
            decoration: BoxDecoration(
              color: AppDesign.card,
              borderRadius: BorderRadius.circular(AppDesign.radiusL),
              boxShadow: AppDesign.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppDesign.booking.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppDesign.booking,
                  ),
                ),
                const SizedBox(width: AppDesign.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_filteredEquipment.length} equipment nearby',
                        style: AppDesign.titleMedium,
                      ),
                      Text('Drag map to explore', style: AppDesign.caption),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppDesign.bookingAccentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
