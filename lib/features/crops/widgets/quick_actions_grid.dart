import 'package:flutter/material.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flash_on,
                    color: Color(0xFF9C27B0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Actions Grid
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        'Water Log',
                        Icons.water_drop,
                        const Color(0xFF2196F3),
                        () => _showWaterLogDialog(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        'Add Expense',
                        Icons.currency_rupee,
                        const Color(0xFFFF9800),
                        () => _showAddExpenseDialog(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        context,
                        'Schedule Task',
                        Icons.schedule,
                        const Color(0xFF4CAF50),
                        () => _showScheduleTaskDialog(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        context,
                        'View Reports',
                        Icons.assessment,
                        const Color(0xFF9C27B0),
                        () => _showReportsDialog(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWaterLogDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.water_drop, color: Color(0xFF2196F3)),
            SizedBox(width: 8),
            Text('Water Log'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'tomato', child: Text('🍅 Tomato')),
                DropdownMenuItem(value: 'brinjal', child: Text('🍆 Brinjal')),
                DropdownMenuItem(value: 'chili', child: Text('🌶️ Chili')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Water Amount (Liters)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.water_drop),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar(context, 'Water log recorded successfully!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save),
            label: const Text('Log Water'),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.currency_rupee, color: Color(0xFFFF9800)),
            SizedBox(width: 8),
            Text('Add Expense'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'seeds', child: Text('🌱 Seeds')),
                DropdownMenuItem(value: 'fertilizer', child: Text('🧪 Fertilizer')),
                DropdownMenuItem(value: 'pesticides', child: Text('🐛 Pesticides')),
                DropdownMenuItem(value: 'labor', child: Text('👷 Labor')),
                DropdownMenuItem(value: 'irrigation', child: Text('💧 Irrigation')),
                DropdownMenuItem(value: 'other', child: Text('📝 Other')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Related Crop',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'tomato', child: Text('🍅 Tomato')),
                DropdownMenuItem(value: 'brinjal', child: Text('🍆 Brinjal')),
                DropdownMenuItem(value: 'chili', child: Text('🌶️ Chili')),
                DropdownMenuItem(value: 'general', child: Text('🌾 General Farm')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar(context, 'Expense added successfully!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save),
            label: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  void _showScheduleTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.schedule, color: Color(0xFF4CAF50)),
            SizedBox(width: 8),
            Text('Schedule Task'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.task),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Task Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'watering', child: Text('💧 Watering')),
                DropdownMenuItem(value: 'fertilizing', child: Text('🧪 Fertilizing')),
                DropdownMenuItem(value: 'pest_control', child: Text('🐛 Pest Control')),
                DropdownMenuItem(value: 'pruning', child: Text('✂️ Pruning')),
                DropdownMenuItem(value: 'harvesting', child: Text('🌾 Harvesting')),
                DropdownMenuItem(value: 'other', child: Text('📝 Other')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Crop',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'tomato', child: Text('🍅 Tomato')),
                DropdownMenuItem(value: 'brinjal', child: Text('🍆 Brinjal')),
                DropdownMenuItem(value: 'chili', child: Text('🌶️ Chili')),
                DropdownMenuItem(value: 'all', child: Text('🌾 All Crops')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Due Date',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
                hintText: 'Select date',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar(context, 'Task scheduled successfully!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.schedule),
            label: const Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _showReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.assessment, color: Color(0xFF9C27B0)),
            SizedBox(width: 8),
            Text('Financial Reports'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildReportTile(
              'Expense Report',
              'View detailed expense breakdown',
              Icons.trending_down,
              const Color(0xFFE53935),
              () => Navigator.pop(context),
            ),
            const Divider(),
            _buildReportTile(
              'Sales Report',
              'Track revenue and sales',
              Icons.trending_up,
              const Color(0xFF4CAF50),
              () => Navigator.pop(context),
            ),
            const Divider(),
            _buildReportTile(
              'Profit Analysis',
              'Analyze profit margins',
              Icons.analytics,
              const Color(0xFF2196F3),
              () => Navigator.pop(context),
            ),
            const Divider(),
            _buildReportTile(
              'Seasonal Comparison',
              'Compare with previous seasons',
              Icons.compare,
              const Color(0xFFFF9800),
              () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}