import 'package:flutter/material.dart';
import 'theme.dart';
import 'crop_service.dart';
import 'api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'disease_detection_page.dart';
import 'schemes_page.dart';

void main() {
  runApp(const SahayakApp());
}

class SahayakApp extends StatelessWidget {
  const SahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahayak AI',
      theme: getSahayakTheme(),
      home: const MainTabScaffold(),
      debugShowCheckedModeBanner: false,
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
    const MyCropsTab(),
    const DiseaseDetectionPage(),
    Center(child: Text('Market (Coming Soon)')),
    const SchemesPage(),
  ];

  void _onItemTapped(int index) {
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
    return SingleChildScrollView(
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
                        child: const Text(
                          '3',
                          style: TextStyle(color: Colors.white, fontSize: 10),
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
                decoration: BoxDecoration(
                  color: const Color(0xFFB2DFDB),
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
          Card(
            color: const Color(0xFF43A047),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Today's Weather",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '28°C',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Partly Cloudy',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: const [
                      Icon(Icons.cloud, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text('65%', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Market Snapshot card
          Card(
            color: const Color(0xFFFFA726),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Market Snapshot',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Tomato', style: TextStyle(color: Colors.white)),
                      Text('₹25/kg ↑', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Brinjal', style: TextStyle(color: Colors.white)),
                      Text('₹18/kg ↓', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Chili', style: TextStyle(color: Colors.white)),
                      Text('₹45/kg ↑', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Sahayak Says card
          Card(
            color: const Color(0xFFE8F5E9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.campaign, color: Color(0xFF388E3C)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Sahayak Says:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF388E3C),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your brinjal crop is looking excellent! Consider harvesting in 2-3 days when prices are expected to rise. The weather is perfect for the next few days.',
                        ),
                        SizedBox(height: 8),
                        Text(
                          '🔊 Listen to tip',
                          style: TextStyle(
                            color: Color(0xFF388E3C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- My Crops Tab Implementation ---

class MyCropsTab extends StatelessWidget {
  const MyCropsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App bar row
          Row(
            children: [
              const Text(
                'My Crops',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Color(0xFF388E3C)),
                onPressed: () {},
                tooltip: 'Add Crop',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Farm Overview Card
          Card(
            color: const Color(0xFFE8F5E9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Farm Overview',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF388E3C),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₹28,000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF388E3C),
                          ),
                        ),
                        Text(
                          'Total Investment',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 48, color: Colors.black12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 8),
                        Text(
                          '₹65,000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA726),
                          ),
                        ),
                        Text(
                          'Expected Revenue',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 48, color: Colors.black12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 8),
                        Text(
                          '₹37,000',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF388E3C),
                          ),
                        ),
                        Text(
                          'Profit Margin',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Crop List
          const Text(
            'My Crops',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          CropListWidget(),
          const SizedBox(height: 16),
          // Alerts & Updates
          const Text(
            'Alerts & Updates',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          AlertsWidget(),
        ],
      ),
    );
  }
}

class CropListWidget extends StatelessWidget {
  const CropListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for crops
    final crops = [
      {
        'name': 'Tomato',
        'health': 80,
        'status': 'Flowering',
        'nextAction': 'Apply fertilizer in 2 days',
        'issues': ['Leaf curl noticed', 'Some pest activity'],
      },
      {
        'name': 'Brinjal',
        'health': 90,
        'status': 'Ready for harvest',
        'nextAction': 'Harvest in 3 days',
        'issues': <String>[],
      },
      {
        'name': 'Chili',
        'health': 70,
        'status': 'Growing',
        'nextAction': 'Pest check',
        'issues': ['Some pest activity'],
      },
    ];
    return Column(
      children: crops.map((crop) {
        final String name = crop['name'] as String;
        final int health = crop['health'] as int;
        final String status = crop['status'] as String;
        final String nextAction = crop['nextAction'] as String;
        final List<String> issues = List<String>.from(crop['issues'] as List);
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_florist, color: const Color(0xFF388E3C)),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Color(0xFF388E3C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: health / 100.0,
                        backgroundColor: Colors.grey[200],
                        color: health >= 80
                            ? const Color(0xFF388E3C)
                            : (health >= 60 ? Colors.orange : Colors.red),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$health%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Next: $nextAction',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                if (issues.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Issues:',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...issues
                            .map(
                              (issue) => Text(
                                '- $issue',
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AlertsWidget extends StatelessWidget {
  const AlertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for alerts
    final alerts = [
      {
        'msg': 'Tomato plants need fertilizer in 2 days',
        'color': const Color(0xFFFFF3E0),
      },
      {
        'msg': 'Brinjal harvest is ready in 3 days',
        'color': const Color(0xFFE8F5E9),
      },
      {
        'msg': 'New government schemes available',
        'color': const Color(0xFFE3F2FD),
      },
    ];
    return Column(
      children: alerts.map((alert) {
        final String msg = alert['msg'] as String;
        final Color color = alert['color'] as Color;
        return Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.notifications, color: Color(0xFFFFA726)),
            title: Text(msg),
          ),
        );
      }).toList(),
    );
  }
}

// --- End My Crops Tab Implementation ---

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
