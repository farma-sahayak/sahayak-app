import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme.dart';
import 'crop_service.dart';
import 'api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'disease_detection_page.dart';
import 'schemes_page.dart';
import 'features/market/market.dart';
import 'features/home/home.dart';
import 'features/crops/crops.dart';

void main() {
  runApp(const SahayakApp());
}

class SahayakApp extends StatelessWidget {
  const SahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MarketBloc(
            repository: MarketRepository(),
          )..add(const LoadMarketPrices()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(
            repository: HomeRepository(),
          )..add(const LoadHomeData()),
        ),
        BlocProvider(
          create: (context) => CropsBloc(
            repository: CropsRepository(),
          )..add(const LoadCrops()),
        ),
      ],
      child: MaterialApp(
        title: 'Sahayak AI',
        theme: getSahayakTheme(),
        home: const MainTabScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({super.key});

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();
}

class _MainTabScaffoldState extends State<MainTabScaffold> {
  int _selectedIndex = 0;

  static final List<Widget> _tabs = <Widget>[
    const HomeTab(),
    const MyCropsPage(),
    const DiseaseDetectionPage(),
    const MarketPage(),
    const SchemesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _tabs[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF388E3C),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'My Crops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Disease',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee),
            label: 'Market',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.policy), label: 'Schemes'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const RefreshHomeData());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar row
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF388E3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                        side: const BorderSide(color: Color(0xFFB2DFDB)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                      icon: const Icon(Icons.download),
                      label: const Text('Install App'),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications_none, color: Colors.black),
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
                                style: const TextStyle(color: Colors.white, fontSize: 10),
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
                const SizedBox(height: 8),
                const Text(
                  'Good morning, user! • 12:29 am',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 16),
                // Ask Sahayak Anything
                Card(
                  color: const Color(0xFFE8F5E9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFB2DFDB),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.mic, color: Color(0xFF388E3C)),
                    ),
                    title: const Text(
                      'Ask Sahayak Anything',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Tap the mic to speak in Kannada or English',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
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
                        color: const Color(0xFF43A047).withOpacity(0.3),
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
                          color: Colors.white.withOpacity(0.2),
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
                        color: const Color(0xFFFFA726).withOpacity(0.3),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
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
                      _buildMarketRow('🍆', 'Brinjal', '₹18/kg', '-5%', false),
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
                      color: const Color(0xFF388E3C).withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF388E3C).withOpacity(0.1),
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
                              color: const Color(0xFF388E3C).withOpacity(0.1),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF388E3C).withOpacity(0.1),
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF388E3C),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.volume_up, color: Colors.white, size: 16),
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
          color: const Color(0xFF388E3C).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: const Color(0xFF388E3C).withOpacity(0.1),
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
                  .map((crop) => CropCard(
                        crop: crop,
                        onTap: () {
                          // Navigate to crop details
                        },
                      ))
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
          color: const Color(0xFF388E3C).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: const Color(0xFFFFA726).withOpacity(0.1),
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
                  .map((notification) => NotificationCard(
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
                      ))
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
          color: const Color(0xFF388E3C).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: const Color(0xFF9C27B0).withOpacity(0.1),
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
                       // Navigate to market tab
                       final mainTabScaffold = context.findAncestorStateOfType<_MainTabScaffoldState>();
                       mainTabScaffold?.changeTab(3);
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
                       // Navigate to my crops tab
                       final mainTabScaffold = context.findAncestorStateOfType<_MainTabScaffoldState>();
                       mainTabScaffold?.changeTab(1);
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

  Widget _buildMarketRow(String emoji, String crop, String price, String change, bool isUp) {
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
                ? Colors.green.withOpacity(0.3)
                : Colors.red.withOpacity(0.3),
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

// --- My Crops Tab Implementation ---

// --- Old My Crops Implementation Removed - Using new BLoC-based implementation ---

// === CHAT SCREEN IMPLEMENTATION ===
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final String _farmerId = "farmer_123"; // In real app, get from auth

  @override
  void initState() {
    super.initState();
    // Add initial greeting
    _messages.add(ChatMessage(
      text: "Namaste! I'm Sahayak, your farming assistant. How can I help you today?",
      isFromUser: false,
      timestamp: DateTime.now(),
      suggestions: ["Check my crops", "Market prices", "Weather update", "Government schemes"],
    ));
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isFromUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await ApiService.sendMessage(text, _farmerId);
      
      setState(() {
        _messages.add(ChatMessage(
          text: response['response'] ?? 'I received your message.',
          isFromUser: false,
          timestamp: DateTime.now(),
          suggestions: response['suggestions']?.cast<String>(),
          intent: response['intent'],
          agent: response['agent'],
        ));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I am having technical difficulties. Please try again.',
          isFromUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Sahayak'),
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              // TODO: Implement voice input
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice input coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return const ChatBubble(
                    text: "Typing...",
                    isFromUser: false,
                    isLoading: true,
                  );
                }
                
                final message = _messages[index];
                return ChatBubble(
                  text: message.text,
                  isFromUser: message.isFromUser,
                  timestamp: message.timestamp,
                  suggestions: message.suggestions,
                  onSuggestionTap: (suggestion) => _sendMessage(suggestion),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _sendMessage(_messageController.text),
                  backgroundColor: const Color(0xFF388E3C),
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final List<String>? suggestions;
  final String? intent;
  final String? agent;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.suggestions,
    this.intent,
    this.agent,
  });
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isFromUser;
  final DateTime? timestamp;
  final List<String>? suggestions;
  final Function(String)? onSuggestionTap;
  final bool isLoading;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isFromUser,
    this.timestamp,
    this.suggestions,
    this.onSuggestionTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: isFromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isFromUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF388E3C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.agriculture, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isFromUser ? const Color(0xFF388E3C) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 40,
                          height: 20,
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      : Text(
                          text,
                          style: TextStyle(
                            color: isFromUser ? Colors.white : Colors.black87,
                          ),
                        ),
                ),
              ),
              if (isFromUser) ...[
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.grey, size: 16),
                ),
              ],
            ],
          ),
          if (suggestions != null && suggestions!.isNotEmpty && !isFromUser) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: suggestions!.map((suggestion) {
                  return GestureDetector(
                    onTap: () => onSuggestionTap?.call(suggestion),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF388E3C)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          color: Color(0xFF388E3C),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
