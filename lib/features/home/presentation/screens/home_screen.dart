import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/disease_detection_page.dart';
import 'package:mobile/features/home/data/models/quick_action.dart';
import 'package:mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:mobile/features/home/presentation/bloc/home_event.dart';
import 'package:mobile/features/home/presentation/bloc/home_state.dart';
import 'package:mobile/features/home/presentation/widgets/crop_card.dart';
import 'package:mobile/features/home/presentation/widgets/notification_card.dart';
import 'package:mobile/features/home/presentation/widgets/quick_action_button.dart';
import 'package:mobile/features/schemes/presentation/pages/schemes_page.dart';
import 'package:mobile/main_tab_scaffold.dart';
import 'package:mobile/shared/widgets/app_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sahayak"),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Hari Singh"),
              accountEmail: Text("harisingh@gmail.com"),
              decoration: BoxDecoration(color: Color(0xFF388E3C)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Details"),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () => {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () => {},
            ),
          ],
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(const RefreshHomeData());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar row
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_none,
                              color: Colors.black,
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  state is HomeLoaded
                                      ? '${state.notifications.where((n) => !n.isRead).length}'
                                      : '3',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.language, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  // const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Good morning, user! • 12:29 am',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: AppConstants.screenPadding),
                  // Ask Sahayak Anything
                  AppCard(
                    color: const Color(0xFFE8F5E9),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFB2DFDB),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(
                          AppConstants.smallPadding,
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: Color(0xFF388E3C),
                          size: AppConstants.iconMedium,
                        ),
                      ),
                      title: Text(
                        'Ask Sahayak Anything',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Tap the mic to speak in Kannada or English',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppConstants.screenPadding),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.black12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search crops, diseases, schemes…',
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Weather card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF43A047).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Today's Weather",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '28°C',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Partly Cloudy • Humidity 65%',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.wb_sunny,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Market Snapshot card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFA726).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Market Snapshot',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Live',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildMarketRow('🍅', 'Tomato', '₹25/kg', '+8%', true),
                        const SizedBox(height: 8),
                        _buildMarketRow(
                          '🍆',
                          'Brinjal',
                          '₹18/kg',
                          '-5%',
                          false,
                        ),
                        const SizedBox(height: 8),
                        _buildMarketRow('🌶️', 'Chili', '₹45/kg', '+12%', true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sahayak Says card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF388E3C).withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF388E3C).withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF388E3C,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.smart_toy,
                                color: Color(0xFF388E3C),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Sahayak Says:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF388E3C),
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF388E3C,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'AI Tip',
                                style: TextStyle(
                                  color: Color(0xFF388E3C),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your brinjal crop is looking excellent! Consider harvesting in 2-3 days when prices are expected to rise. The weather is perfect for the next few days.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF388E3C),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Listen to tip',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF388E3C),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.share,
                                color: Color(0xFF388E3C),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // My Crops Section
                  _buildMyCropsSection(context, state),
                  const SizedBox(height: 20),
                  // Alerts & Updates Section
                  _buildAlertsSection(context, state),
                  const SizedBox(height: 20),
                  // Quick Actions Section
                  _buildQuickActionsSection(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyCropsSection(BuildContext context, HomeState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF388E3C).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF388E3C).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: Color(0xFF388E3C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'My Crops',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF388E3C),
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state is HomeLoading)
            const Center(child: CircularProgressIndicator())
          else if (state is HomeLoaded)
            Column(
              children: state.crops
                  .map(
                    (crop) => CropCard(
                      crop: crop,
                      onTap: () {
                        // Navigate to crop details
                      },
                    ),
                  )
                  .toList(),
            )
          else if (state is HomeError)
            Center(
              child: Text(
                'Error loading crops: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            const Center(child: Text('No crops available')),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(BuildContext context, HomeState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF388E3C).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA726).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning,
                  color: Color(0xFFFFA726),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Alerts & Updates',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFA726),
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state is HomeLoading)
            const Center(child: CircularProgressIndicator())
          else if (state is HomeLoaded)
            Column(
              children: state.notifications
                  .map(
                    (notification) => NotificationCard(
                      notification: notification,
                      onTap: () {
                        context.read<HomeBloc>().add(
                          MarkNotificationAsRead(notification.id),
                        );
                      },
                      onPlayAudio: () {
                        context.read<HomeBloc>().add(
                          PlayNotificationAudio(notification.id),
                        );
                      },
                    ),
                  )
                  .toList(),
            )
          else if (state is HomeError)
            Center(
              child: Text(
                'Error loading notifications: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            const Center(child: Text('No notifications available')),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF388E3C).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Color(0xFF9C27B0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9C27B0),
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                children: [
                  QuickActionButton(
                    action: QuickActions.defaultActions[0],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiseaseDetectionPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  QuickActionButton(
                    action: QuickActions.defaultActions[1],
                    onTap: () {
                      // TODO: Navigate to market tab
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  QuickActionButton(
                    action: QuickActions.defaultActions[2],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SchemesPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  QuickActionButton(
                    action: QuickActions.defaultActions[3],
                    onTap: () {
                      //TODO: Navigate to my crops tab
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketRow(
    String emoji,
    String crop,
    String price,
    String change,
    bool isUp,
  ) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            crop,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isUp
                ? Colors.green.withValues(alpha: 0.3)
                : Colors.red.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            change,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
