import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../widgets/premium_components.dart';
import '../../data/mock_data.dart';
import 'add_equipment_screen.dart';

class MyEquipmentScreen extends StatelessWidget {
  const MyEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final equipment = MockDataRepository.userEquipment;

    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: const Text('My Equipment'),
        backgroundColor: ProviderColors.background,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: equipment.isEmpty
          ? _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: equipment.length,
              itemBuilder: (context, index) {
                final item = equipment[index];
                return _EquipmentCard(equipment: item);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEquipmentScreen()),
          );
        },
        backgroundColor: ProviderColors.accent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add New',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ProviderColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.agriculture_outlined,
              size: 64,
              color: ProviderColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No equipment added yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ProviderColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first machine to start earning!',
            style: GoogleFonts.inter(color: ProviderColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final Map<String, dynamic> equipment;

  const _EquipmentCard({required this.equipment});

  @override
  Widget build(BuildContext context) {
    final isAvailable = equipment['status'] == 'Available';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ProviderColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ProviderColors.primaryLight.withValues(alpha: 0.3),
                  ProviderColors.secondary.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.agriculture,
                    size: 64,
                    color: ProviderColors.primary,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: StatusBadge(
                    label: equipment['status'] as String,
                    color: isAvailable
                        ? ProviderColors.success
                        : ProviderColors.warning,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        equipment['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ProviderColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                      color: ProviderColors.textMuted,
                    ),
                  ],
                ),
                Text(
                  equipment['type'] as String,
                  style: GoogleFonts.inter(
                    color: ProviderColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.star,
                      label: '${equipment['rating']}',
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 12),
                    _InfoChip(
                      icon: Icons.work_outline,
                      label: '${equipment['totalBookings']} jobs',
                      color: ProviderColors.primary,
                    ),
                    const Spacer(),
                    Text(
                      '₹${equipment['pricePerDay']}/day',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ProviderColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
