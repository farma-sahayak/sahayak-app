import 'package:flutter/material.dart';
import 'shared/constants/app_constants.dart';
import 'shared/widgets/app_header.dart';
import 'shared/widgets/app_card.dart';

class DiseaseDetectionPage extends StatelessWidget {
  const DiseaseDetectionPage({Key? key}) : super(key: key);

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
                title: 'Disease Detection',
                subtitle: 'Take a photo or describe symptoms',
                leadingIcon: Icons.camera_alt,
              ),
              const SizedBox(height: AppConstants.largePadding),

            // Analyze Plant Disease Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Analyze Plant Disease',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: AppConstants.screenPadding),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.largePadding),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF388E3C).withOpacity(0.3),
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: AppConstants.iconXLarge + 16,
                          color: const Color(0xFF388E3C),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Text(
                          'Take Photo or tap to upload',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF388E3C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.screenPadding),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement describe problem action
                    },
                    icon: const Icon(Icons.mic, size: AppConstants.iconMedium),
                    label: const Text('Describe Problem'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tips for Best Results Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber[800],
                        ), // Replace with appropriate icon
                        const SizedBox(width: 8),
                        Text(
                          'Tips for Best Results',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Photo Tips',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Good light, focus on affected area',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.mic,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Voice Tips',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Describe symptoms clearly',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement sample photos action
                          },
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Sample Photos'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement audio guide action
                          },
                          icon: const Icon(Icons.volume_up),
                          label: const Text('Audio Guide'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
