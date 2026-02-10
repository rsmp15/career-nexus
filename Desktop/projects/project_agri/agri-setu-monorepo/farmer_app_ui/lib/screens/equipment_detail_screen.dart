import 'package:flutter/material.dart';
import '../../core/design_system.dart';
import '../../data/booking_data.dart';

class EquipmentDetailScreen extends StatefulWidget {
  final Equipment equipment;

  const EquipmentDetailScreen({super.key, required this.equipment});

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  bool _isFavorite = false;
  int _selectedHours = 4;

  Equipment get eq => widget.equipment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.background,
      body: Stack(
        children: [
          // ════════════════════════════════════════════════════════════════
          // HERO IMAGE
          // ════════════════════════════════════════════════════════════════
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(eq.imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppDesign.background.withOpacity(0.3),
                        AppDesign.background,
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                  ),
                ),

                // Top buttons
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: AppDesign.spaceL,
                  right: AppDesign.spaceL,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GlassIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          GlassIconButton(
                            icon: Icons.share_outlined,
                            onTap: () {},
                          ),
                          const SizedBox(width: AppDesign.spaceS),
                          GlassIconButton(
                            icon: _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            iconColor: _isFavorite ? AppDesign.error : null,
                            onTap: () =>
                                setState(() => _isFavorite = !_isFavorite),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status badge
                Positioned(
                  top: MediaQuery.of(context).padding.top + 70,
                  left: AppDesign.spaceL,
                  child: StatusChip(
                    text: eq.isAvailable ? 'Available Now' : 'Currently Booked',
                    color: eq.isAvailable ? AppDesign.success : AppDesign.error,
                    icon: eq.isAvailable ? Icons.check_circle : Icons.cancel,
                  ),
                ),
              ],
            ),
          ),

          // ════════════════════════════════════════════════════════════════
          // CONTENT
          // ════════════════════════════════════════════════════════════════
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: AppDesign.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDesign.radiusXL),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView(
                  controller: controller,
                  padding: EdgeInsets.only(
                    top: AppDesign.spaceL,
                    left: AppDesign.spaceL,
                    right: AppDesign.spaceL,
                    bottom: 140,
                  ),
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppDesign.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDesign.spaceL),

                    // Title & Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppDesign.booking.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  eq.categoryLabel,
                                  style: AppDesign.caption.copyWith(
                                    color: AppDesign.booking,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDesign.spaceS),
                              Text(eq.name, style: AppDesign.displayMedium),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppDesign.bookingAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              AppDesign.radiusM,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: AppDesign.bookingAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${eq.rating}',
                                style: AppDesign.titleMedium.copyWith(
                                  color: AppDesign.bookingAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDesign.spaceM),

                    // Location & Reviews
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppDesign.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${eq.distance} km away',
                          style: AppDesign.bodyMedium,
                        ),
                        const SizedBox(width: AppDesign.spaceL),
                        Icon(
                          Icons.reviews_outlined,
                          size: 16,
                          color: AppDesign.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${eq.reviews} reviews',
                          style: AppDesign.bodyMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDesign.spaceXL),

                    // ════════════════════════════════════════════════════════
                    // SPECIFICATIONS
                    // ════════════════════════════════════════════════════════
                    Text('Specifications', style: AppDesign.headlineMedium),
                    const SizedBox(height: AppDesign.spaceM),

                    Row(
                      children: [
                        Expanded(
                          child: _buildSpecCard(
                            Icons.local_gas_station,
                            'Fuel',
                            eq.fuelType,
                            AppDesign.warning,
                          ),
                        ),
                        const SizedBox(width: AppDesign.spaceM),
                        Expanded(
                          child: _buildSpecCard(
                            Icons.verified,
                            'Condition',
                            eq.condition,
                            AppDesign.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDesign.spaceM),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSpecCard(
                            Icons.access_time,
                            'Rental',
                            'Hourly',
                            AppDesign.booking,
                          ),
                        ),
                        const SizedBox(width: AppDesign.spaceM),
                        Expanded(
                          child: _buildSpecCard(
                            Icons.engineering,
                            'Type',
                            'Manual',
                            AppDesign.socialLight,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDesign.spaceXL),

                    // ════════════════════════════════════════════════════════
                    // FEATURES
                    // ════════════════════════════════════════════════════════
                    Text('Features', style: AppDesign.headlineMedium),
                    const SizedBox(height: AppDesign.spaceM),

                    Wrap(
                      spacing: AppDesign.spaceS,
                      runSpacing: AppDesign.spaceS,
                      children: eq.features.map((feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppDesign.card,
                            borderRadius: BorderRadius.circular(
                              AppDesign.radiusFull,
                            ),
                            border: Border.all(color: AppDesign.divider),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppDesign.booking,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                feature,
                                style: AppDesign.labelMedium.copyWith(
                                  color: AppDesign.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: AppDesign.spaceXL),

                    // ════════════════════════════════════════════════════════
                    // DESCRIPTION
                    // ════════════════════════════════════════════════════════
                    Text('Description', style: AppDesign.headlineMedium),
                    const SizedBox(height: AppDesign.spaceM),
                    Text(eq.description, style: AppDesign.bodyLarge),

                    const SizedBox(height: AppDesign.spaceXL),

                    // ════════════════════════════════════════════════════════
                    // OWNER
                    // ════════════════════════════════════════════════════════
                    GlassCard(
                      borderColor: AppDesign.booking.withOpacity(0.3),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppDesign.booking,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(eq.ownerAvatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDesign.spaceM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  eq.ownerName,
                                  style: AppDesign.titleMedium,
                                ),
                                Text(
                                  'Equipment Owner',
                                  style: AppDesign.caption,
                                ),
                              ],
                            ),
                          ),
                          _buildContactButton(Icons.phone, AppDesign.success),
                          const SizedBox(width: AppDesign.spaceS),
                          _buildContactButton(
                            Icons.chat_bubble_outline,
                            AppDesign.booking,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ════════════════════════════════════════════════════════════════
          // BOTTOM CTA
          // ════════════════════════════════════════════════════════════════
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: AppDesign.spaceL,
                right: AppDesign.spaceL,
                top: AppDesign.spaceM,
                bottom:
                    MediaQuery.of(context).padding.bottom + AppDesign.spaceM,
              ),
              decoration: BoxDecoration(
                color: AppDesign.surface,
                border: Border(top: BorderSide(color: AppDesign.divider)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Price per hour', style: AppDesign.caption),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GradientText(
                            text: '₹${eq.pricePerHour.toInt()}',
                            style: AppDesign.displayMedium,
                            gradient: AppDesign.bookingAccentGradient,
                          ),
                          Text('/hr', style: AppDesign.bodyMedium),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(width: AppDesign.spaceL),

                  // Book button
                  Expanded(
                    child: GlowButton(
                      text: 'Book Now',
                      icon: Icons.calendar_today,
                      gradient: AppDesign.bookingAccentGradient,
                      onPressed: () => _showBookingSheet(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDesign.spaceM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDesign.radiusM),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDesign.spaceM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppDesign.caption),
              Text(value, style: AppDesign.titleMedium.copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              top: AppDesign.spaceL,
              left: AppDesign.spaceL,
              right: AppDesign.spaceL,
              bottom: MediaQuery.of(context).padding.bottom + AppDesign.spaceL,
            ),
            decoration: const BoxDecoration(
              color: AppDesign.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDesign.radiusXL),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppDesign.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppDesign.spaceL),

                Text('Book Equipment', style: AppDesign.headlineMedium),
                const SizedBox(height: AppDesign.spaceM),

                // Equipment summary
                Container(
                  padding: const EdgeInsets.all(AppDesign.spaceM),
                  decoration: BoxDecoration(
                    color: AppDesign.card,
                    borderRadius: BorderRadius.circular(AppDesign.radiusM),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          eq.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppDesign.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(eq.name, style: AppDesign.titleMedium),
                            Text(
                              '₹${eq.pricePerHour.toInt()}/hr',
                              style: AppDesign.bodyMedium.copyWith(
                                color: AppDesign.booking,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDesign.spaceL),

                // Hours selector
                Text('Select Duration', style: AppDesign.titleMedium),
                const SizedBox(height: AppDesign.spaceM),
                Row(
                  children: [2, 4, 6, 8].map((hours) {
                    final isSelected = _selectedHours == hours;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setSheetState(() => _selectedHours = hours),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppDesign.bookingAccentGradient
                                : null,
                            color: isSelected ? null : AppDesign.card,
                            borderRadius: BorderRadius.circular(
                              AppDesign.radiusM,
                            ),
                            border: isSelected
                                ? null
                                : Border.all(color: AppDesign.divider),
                          ),
                          child: Text(
                            '${hours}h',
                            style: AppDesign.titleMedium.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppDesign.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppDesign.spaceL),

                // Total
                Container(
                  padding: const EdgeInsets.all(AppDesign.spaceM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppDesign.booking.withOpacity(0.15),
                        AppDesign.bookingLight.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDesign.radiusM),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: AppDesign.titleMedium),
                      GradientText(
                        text: '₹${(eq.pricePerHour * _selectedHours).toInt()}',
                        style: AppDesign.headlineLarge,
                        gradient: AppDesign.bookingAccentGradient,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDesign.spaceL),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: GlowButton(
                    text: 'Confirm Booking',
                    icon: Icons.check_circle,
                    gradient: AppDesign.bookingAccentGradient,
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking confirmed! 🎉'),
                          backgroundColor: AppDesign.success,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
