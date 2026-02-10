import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import '../../theme/provider_colors.dart';
import '../../widgets/premium_components.dart';

class AddMachineScreen extends StatefulWidget {
  final Machine? machine;
  const AddMachineScreen({super.key, this.machine});

  @override
  State<AddMachineScreen> createState() => _AddMachineScreenState();
}

class _AddMachineScreenState extends State<AddMachineScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController; // Per day rate
  late String _selectedCategory;
  File? _imageFile;
  bool _isLoading = false;

  final List<String> _categories = [
    'Tractor',
    'Harvester',
    'Seeder',
    'Sprayer',
    'Tiller',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.machine;
    _nameController = TextEditingController(text: m?.name ?? '');
    _descController = TextEditingController(text: m?.description ?? '');
    // Mapping PricePerHour (model) to PricePerDay (UI) - handling potential format
    _priceController = TextEditingController(text: m?.pricePerHour ?? '');
    _selectedCategory = m?.category ?? 'Tractor';
    if (!_categories.contains(_selectedCategory)) {
      _selectedCategory = 'Other';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // If creating, image is required. If editing, valid to accept null (no change)
    if (widget.machine == null && _imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.machine == null) {
        // Create
        await context.read<InventoryService>().addMachine(
          name: _nameController.text,
          category: _selectedCategory,
          pricePerDay: double.parse(_priceController.text),
          description: _descController.text,
          imagePath: _imageFile!.path,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Machine added successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        // Update
        final updatedMachine = widget.machine!.copyWith(
          name: _nameController.text,
          category: _selectedCategory,
          pricePerHour: _priceController.text,
          description: _descController.text,
          // image handled by service if path provided, else ignored
        );

        await context.read<InventoryService>().updateMachine(
          updatedMachine, // Use copyWith to update local fields
          imagePath: _imageFile?.path,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Machine updated successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.machine != null;
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Machine' : 'Add New Machine',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ProviderColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: ProviderColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : (isEditing && widget.machine!.image != null
                              ? DecorationImage(
                                  image: NetworkImage(widget.machine!.image!),
                                  fit: BoxFit.cover,
                                )
                              : null),
                  ),
                  child:
                      (_imageFile == null &&
                          (!isEditing || widget.machine!.image == null))
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: ProviderColors.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to upload image',
                              style: GoogleFonts.inter(
                                color: ProviderColors.textSecondary,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              Text(
                'Machine Details',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ProviderColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _nameController,
                label: 'Machine Name',
                hint: 'e.g. John Deere 5050D',
                icon: Icons.agriculture,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: _inputDecoration('Category', Icons.category),
                items: _categories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _priceController,
                label: 'Price per Day (₹)',
                hint: 'e.g. 1500',
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descController,
                label: 'Description',
                hint: 'Features, condition, etc.',
                icon: Icons.description,
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: isEditing ? 'Update Machine' : 'Add Machine',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _inputDecoration(label, icon, hint: hint),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      style: GoogleFonts.inter(color: ProviderColors.textPrimary),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: ProviderColors.textSecondary),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ProviderColors.primary, width: 1.5),
      ),
      labelStyle: GoogleFonts.inter(color: ProviderColors.textSecondary),
      hintStyle: GoogleFonts.inter(color: ProviderColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
