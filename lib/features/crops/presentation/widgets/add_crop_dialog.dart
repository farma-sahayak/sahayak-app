import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/crops_bloc.dart';
import '../bloc/crops_event.dart';
import '../bloc/crops_state.dart';

class AddCropDialog extends StatefulWidget {
  const AddCropDialog({super.key});

  @override
  State<AddCropDialog> createState() => _AddCropDialogState();
}

class _AddCropDialogState extends State<AddCropDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _acresController = TextEditingController();
  final _investmentController = TextEditingController();
  final _revenueController = TextEditingController();
  
  String _selectedCrop = 'tomato';
  DateTime _plantedDate = DateTime.now();
  DateTime? _harvestDate;

  final Map<String, Map<String, String>> _cropData = {
    'tomato': {'name': 'Tomato', 'emoji': '🍅'},
    'brinjal': {'name': 'Brinjal', 'emoji': '🍆'},
    'chili': {'name': 'Chili', 'emoji': '🌶️'},
    'rice': {'name': 'Rice', 'emoji': '🌾'},
    'wheat': {'name': 'Wheat', 'emoji': '🌽'},
    'potato': {'name': 'Potato', 'emoji': '🥔'},
    'onion': {'name': 'Onion', 'emoji': '🧅'},
    'carrot': {'name': 'Carrot', 'emoji': '🥕'},
    'cucumber': {'name': 'Cucumber', 'emoji': '🥒'},
    'corn': {'name': 'Corn', 'emoji': '🌽'},
  };

  @override
  void initState() {
    super.initState();
    _nameController.text = _cropData[_selectedCrop]!['name']!;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _acresController.dispose();
    _investmentController.dispose();
    _revenueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CropsBloc, CropsState>(
      listener: (context, state) {
        if (state is CropAdded) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('${state.crop.name} added successfully!'),
                ],
              ),
              backgroundColor: const Color(0xFF4CAF50),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else if (state is CropAddError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Error: ${state.message}'),
                ],
              ),
              backgroundColor: const Color(0xFFE53935),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.agriculture, color: Color(0xFF388E3C)),
            SizedBox(width: 8),
            Text('Add New Crop'),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Crop Selection
                  DropdownButtonFormField<String>(
                    value: _selectedCrop,
                    decoration: const InputDecoration(
                      labelText: 'Select Crop Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.eco),
                    ),
                    items: _cropData.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          children: [
                            Text(entry.value['emoji']!, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(entry.value['name']!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCrop = value!;
                        _nameController.text = _cropData[_selectedCrop]!['name']!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Crop Name (Editable)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Crop Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label),
                      hintText: 'Enter custom name if needed',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter crop name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Farm Area
                  TextFormField(
                    controller: _acresController,
                    decoration: const InputDecoration(
                      labelText: 'Farm Area (acres)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.landscape),
                      suffixText: 'acres',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter farm area';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Please enter a valid area';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Planted Date
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today, color: Color(0xFF388E3C)),
                    title: const Text('Planted Date'),
                    subtitle: Text(_formatDate(_plantedDate)),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _selectPlantedDate(context),
                  ),
                  const SizedBox(height: 8),

                  // Expected Harvest Date (Optional)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_available, color: Color(0xFF4CAF50)),
                    title: const Text('Expected Harvest Date (Optional)'),
                    subtitle: Text(_harvestDate != null ? _formatDate(_harvestDate!) : 'Not set'),
                    trailing: const Icon(Icons.edit),
                    onTap: () => _selectHarvestDate(context),
                  ),
                  const SizedBox(height: 16),

                  // Total Investment
                  TextFormField(
                    controller: _investmentController,
                    decoration: const InputDecoration(
                      labelText: 'Total Investment',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.trending_down),
                      prefixText: '₹ ',
                      hintText: 'Seeds, fertilizer, labor, etc.',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total investment';
                      }
                      if (double.tryParse(value) == null || double.parse(value) < 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Expected Revenue
                  TextFormField(
                    controller: _revenueController,
                    decoration: const InputDecoration(
                      labelText: 'Expected Revenue',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.trending_up),
                      prefixText: '₹ ',
                      hintText: 'Estimated sales value',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expected revenue';
                      }
                      if (double.tryParse(value) == null || double.parse(value) < 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Profit Preview
                  if (_investmentController.text.isNotEmpty && _revenueController.text.isNotEmpty)
                    _buildProfitPreview(),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          BlocBuilder<CropsBloc, CropsState>(
            builder: (context, state) {
              final isLoading = state is CropAdding;
              return ElevatedButton.icon(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.add),
                label: Text(isLoading ? 'Adding...' : 'Add Crop'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfitPreview() {
    final investment = double.tryParse(_investmentController.text) ?? 0;
    final revenue = double.tryParse(_revenueController.text) ?? 0;
    final profit = revenue - investment;
    final profitPercentage = investment > 0 ? (profit / investment) * 100 : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: profit >= 0 ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: profit >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Profit Preview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: profit >= 0 ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expected Profit:',
                style: TextStyle(
                  color: profit >= 0 ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                ),
              ),
              Text(
                '₹${profit.toStringAsFixed(0)} (${profitPercentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: profit >= 0 ? const Color(0xFF388E3C) : const Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectPlantedDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _plantedDate = picked;
      });
    }
  }

  Future<void> _selectHarvestDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _harvestDate ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: _plantedDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _harvestDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final investment = double.parse(_investmentController.text);
      final revenue = double.parse(_revenueController.text);
      
      context.read<CropsBloc>().add(
        AddCrop(
          name: _nameController.text.trim(),
          emoji: _cropData[_selectedCrop]!['emoji']!,
          acres: double.parse(_acresController.text),
          plantedDate: _plantedDate,
          expectedHarvestDate: _harvestDate,
          totalInvestment: investment,
          expectedRevenue: revenue,
        ),
      );
    }
  }
}