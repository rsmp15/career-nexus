import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import 'package:agrisetu_ui/agrisetu_ui.dart';
import '../theme/app_design.dart';
import '../widgets/common/glass_icon_button.dart';
import '../widgets/equipment_card.dart';
import 'equipment_detail_screen.dart';

class EquipmentListScreen extends StatefulWidget {
  const EquipmentListScreen({super.key});

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  String _selectedCategory = 'all';
  List<Machine> _machines = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'name': 'All'},
    {'id': 'tractor', 'name': 'Tractors'},
    {'id': 'harvester', 'name': 'Harvesters'},
    {'id': 'plough', 'name': 'Ploughs'},
    {'id': 'sprayer', 'name': 'Sprayers'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchMachines();
  }

  Future<void> _fetchMachines() async {
    setState(() => _isLoading = true);
    try {
      final machines = await context.read<InventoryService>().getMachines(
        category: _selectedCategory == 'all' ? null : _selectedCategory,
      );
      if (mounted) {
        setState(() => _machines = machines);
      }
    } catch (e) {
      if (mounted) {
        debugPrint("Error fetching machines: $e");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onCategoryChanged(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
    });
    _fetchMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.background,
      appBar: AppBar(
        backgroundColor: AppDesign.surface,
        leading: const BackButton(color: AppDesign.textPrimary),
        title: const Text(
          'Rent Equipment',
          style: TextStyle(
            color: AppDesign.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GlassIconButton(icon: Icons.filter_list, onTap: () {}, size: 36),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceM),
            child: TextField(
              style: const TextStyle(color: AppDesign.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search tractors, harvesters...',
                hintStyle: const TextStyle(color: AppDesign.textMuted),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppDesign.textMuted,
                ),
                filled: true,
                fillColor: AppDesign.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),

          // Category Slider
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => _onCategoryChanged(cat['id']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppDesign.booking : AppDesign.card,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? AppDesign.booking
                              : AppDesign.divider,
                        ),
                      ),
                      child: Text(
                        cat['name'],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppDesign.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppDesign.spaceM),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _machines.isEmpty
                ? const Center(
                    child: Text(
                      "No equipment found",
                      style: TextStyle(color: AppDesign.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDesign.spaceL),
                    itemCount: _machines.length,
                    itemBuilder: (context, index) {
                      final machine = _machines[index];
                      return EquipmentCard(
                        machine: machine,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EquipmentDetailScreen(machine: machine),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
