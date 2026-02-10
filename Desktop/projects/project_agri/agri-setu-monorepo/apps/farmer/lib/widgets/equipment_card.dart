import 'package:flutter/material.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import '../theme/app_design.dart';

class EquipmentCard extends StatelessWidget {
  final Machine machine;
  final VoidCallback onTap;
  final VoidCallback? onBookPressed;

  const EquipmentCard({
    super.key,
    required this.machine,
    required this.onTap,
    this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDesign.spaceM),
        padding: const EdgeInsets.all(AppDesign.spaceM),
        decoration: BoxDecoration(
          color: AppDesign.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppDesign.divider),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: machine.image != null
                  ? Image.network(
                      machine.image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: AppDesign.cardLight,
                        child: const Icon(
                          Icons.agriculture,
                          color: AppDesign.textMuted,
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: AppDesign.cardLight,
                      child: const Icon(
                        Icons.agriculture,
                        color: AppDesign.textMuted,
                      ),
                    ),
            ),
            const SizedBox(width: AppDesign.spaceM),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    machine.name,
                    style: const TextStyle(
                      color: AppDesign.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppDesign.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        machine.ownerName ?? 'Unknown',
                        style: AppDesign.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.category,
                        size: 14,
                        color: AppDesign.bookingAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        machine.category,
                        style: AppDesign.caption.copyWith(
                          color: AppDesign.bookingAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${machine.pricePerHour}/hr',
                        style: AppDesign.caption.copyWith(
                          color: AppDesign.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Book Now button
            if (onBookPressed != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onBookPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppDesign.bookingAccentGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Book',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Default style if no callback provided (Just visual)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppDesign.booking.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppDesign.booking.withOpacity(0.5)),
                ),
                child: const Text(
                  'Details',
                  style: TextStyle(
                    color:
                        AppDesign.textPrimary, // Changed for better visibility
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
