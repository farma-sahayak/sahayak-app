import 'package:flutter/material.dart';
import 'theme.dart';
import 'shared/constants/app_constants.dart';
import 'shared/widgets/app_header.dart';
import 'shared/widgets/app_card.dart';

class SchemesPage extends StatelessWidget {
  const SchemesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              AppHeader(
                title: 'Government Schemes',
                subtitle: 'Your Benefits Overview',
                leadingIcon: Icons.policy,
              ),
              const SizedBox(height: AppConstants.largePadding),
              
              // Benefits Overview Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Benefits Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppConstants.mediumPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '₹16,000',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        Text(
                          '3',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Total potential benefit/year', style: TextStyle(color: Colors.black54)),
                        Text('Available now', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatusBox(label: 'Eligible', count: 3, color: Color(0xFFE8F5E9)),
                        _StatusBox(label: 'Applied', count: 1, color: Color(0xFFE3F2FD)),
                        _StatusBox(label: 'Not Eligible', count: 1, color: Color(0xFFFFEBEE)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Available Schemes
            const Text(
              'Available Schemes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Scheme Cards
            _SchemeCard(
              title: 'PM-KISAN',
              subtitle: 'Ministry of Agriculture',
              benefit: '₹ 6,000',
              description: 'Direct income support to farmers with landholding up to 2 hectares',
              status: 'Eligible',
              statusColor: Color(0xFFE8F5E9),
              buttonText: 'Apply Now',
              onButtonPressed: () {},
              date: '31st March 2024',
              tags: ['Small & marginal', 'Land owner'],
            ),
            _SchemeCard(
              title: 'Pradhan Mantri Fasal Bima Yojana',
              subtitle: 'Ministry of Agriculture',
              benefit: '₹ 200,000',
              description: 'Crop insurance scheme providing coverage against crop losses',
              status: 'Applied',
              statusColor: Color(0xFFE3F2FD),
              buttonText: 'Track',
              onButtonPressed: () {},
              date: '31st December 2024',
              tags: ['All farmers', 'Crop insurance'],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatusBox({required this.label, required this.count, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String benefit;
  final String description;
  final String status;
  final Color statusColor;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String date;
  final List<String> tags;
  const _SchemeCard({
    required this.title,
    required this.subtitle,
    required this.benefit,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.buttonText,
    required this.onButtonPressed,
    required this.date,
    required this.tags,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(status, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Benefit: $benefit', style: const TextStyle(fontWeight: FontWeight.bold, color: secondaryColor)),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.black45),
                const SizedBox(width: 4),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tags.map((tag) => Chip(label: Text(tag), backgroundColor: Colors.grey[100])).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(buttonText),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Info'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}