import 'package:flutter/material.dart';
import 'package:mobile/api_service.dart';
import 'package:mobile/disease_detection_page.dart';
import 'package:mobile/features/crops/presentation/pages/my_crops_page.dart';
import 'package:mobile/features/home/presentation/screens/home_screen.dart';
import 'package:mobile/features/market/presentation/pages/market_page.dart';
import 'package:mobile/features/schemes/presentation/pages/schemes_page.dart';

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
    _messages.add(
      ChatMessage(
        text:
            "Namaste! I'm Sahayak, your farming assistant. How can I help you today?",
        isFromUser: false,
        timestamp: DateTime.now(),
        suggestions: [
          "Check my crops",
          "Market prices",
          "Weather update",
          "Government schemes",
        ],
      ),
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text, isFromUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _messageController.clear();

    try {
      final response = await ApiService.sendMessage(text, _farmerId);

      setState(() {
        _messages.add(
          ChatMessage(
            text: response['response'] ?? 'I received your message.',
            isFromUser: false,
            timestamp: DateTime.now(),
            suggestions: response['suggestions']?.cast<String>(),
            intent: response['intent'],
            agent: response['agent'],
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text:
                'Sorry, I am having technical difficulties. Please try again.',
            isFromUser: false,
            timestamp: DateTime.now(),
          ),
        );
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
                  color: Colors.grey.withValues(alpha: 0.2),
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
        crossAxisAlignment: isFromUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isFromUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isFromUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF388E3C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isFromUser
                        ? const Color(0xFF388E3C)
                        : Colors.grey[200],
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
          if (suggestions != null &&
              suggestions!.isNotEmpty &&
              !isFromUser) ...[
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
