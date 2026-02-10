import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/colors.dart';
import '../../widgets/premium_components.dart';

class AddEquipmentScreen extends StatefulWidget {
  const AddEquipmentScreen({super.key});

  @override
  State<AddEquipmentScreen> createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Tractor';
  final List<String> _types = [
    'Tractor',
    'Harvester',
    'Rotavator',
    'Seed Drill',
    'Sprayer',
    'Drone',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: const Text('Add Equipment'),
        backgroundColor: ProviderColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ProviderColors.primary.withValues(alpha: 0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: ProviderColors.softShadow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ProviderColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40,
                          color: ProviderColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload Photos',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ProviderColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add up to 5 images',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: ProviderColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Equipment Type
              Text(
                'Equipment Type',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: ProviderColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedType = type);
                    },
                    selectedColor: ProviderColors.primary,
                    backgroundColor: Colors.white,
                    labelStyle: GoogleFonts.inter(
                      color: isSelected
                          ? Colors.white
                          : ProviderColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? ProviderColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Equipment Name
              _FormField(
                label: 'Equipment Name',
                hint: 'e.g., John Deere 5050D',
              ),
              const SizedBox(height: 16),

              // Price
              _FormField(
                label: 'Price per Day (₹)',
                hint: 'e.g., 2500',
                keyboardType: TextInputType.number,
                prefix: Text(
                  '₹ ',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              _FormField(
                label: 'Description',
                hint: 'Describe your equipment...',
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Add Equipment',
                  icon: Icons.check,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? prefix;

  const _FormField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: ProviderColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: ProviderColors.softShadow,
          ),
          child: TextField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: GoogleFonts.inter(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: prefix,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(minWidth: 0),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
