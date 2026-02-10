import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:agrisetu_api/agrisetu_api.dart';
import '../../theme/provider_colors.dart';
import '../add_machine_screen.dart';

class MyMachinesScreen extends StatefulWidget {
  const MyMachinesScreen({super.key});

  @override
  State<MyMachinesScreen> createState() => _MyMachinesScreenState();
}

class _MyMachinesScreenState extends State<MyMachinesScreen> {
  late Future<List<Machine>> _machinesFuture;

  @override
  void initState() {
    super.initState();
    _refreshMachines();
  }

  void _refreshMachines() {
    setState(() {
      _machinesFuture = context.read<InventoryService>().getMyMachines();
    });
  }

  Future<void> _deleteMachine(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Machine'),
        content: const Text('Are you sure you want to delete this machine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await context.read<InventoryService>().deleteMachine(id);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Machine deleted')));
          _refreshMachines();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _toggleStatus(Machine machine) async {
    // Optimistic UI update or wait for API
    try {
      final newStatus = !machine.isActive;
      // Copy with new status
      final updated = machine.copyWith(isActive: newStatus);
      // Update
      await context.read<InventoryService>().updateMachine(updated);
      if (mounted) {
        _refreshMachines();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProviderColors.background,
      appBar: AppBar(
        title: Text(
          'My Equipment',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: ProviderColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: ProviderColors.textPrimary),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMachineScreen()),
          ).then((_) => _refreshMachines());
        },
        backgroundColor: ProviderColors.accent,
        label: Text(
          'Add Machine',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Machine>>(
        future: _machinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final machines = snapshot.data ?? [];
          if (machines.isEmpty) {
            return Center(
              child: Text(
                "No machines found. Add one!",
                style: GoogleFonts.inter(color: ProviderColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: machines.length,
            itemBuilder: (context, index) {
              final machine = machines[index];
              return _MachineCard(
                machine: machine,
                onDelete: () => _deleteMachine(machine.id),
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddMachineScreen(machine: machine),
                    ),
                  ).then((_) => _refreshMachines());
                },
                onToggleStatus: () => _toggleStatus(machine),
              );
            },
          );
        },
      ),
    );
  }
}

class _MachineCard extends StatelessWidget {
  final Machine machine;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const _MachineCard({
    required this.machine,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ProviderColors.softShadow,
      ),
      child: Column(
        children: [
          // Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: machine.image != null
                      ? Image.network(machine.image!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.agriculture,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onToggleStatus,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: machine.isActive
                          ? ProviderColors.success
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      machine.isActive ? 'Active' : 'Inactive',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            machine.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: ProviderColors.textPrimary,
                            ),
                          ),
                          Text(
                            machine.category,
                            style: GoogleFonts.inter(
                              color: ProviderColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${machine.pricePerHour}/day',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ProviderColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: ProviderColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
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
