import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

mixin VoiceSearchMixin<T extends StatefulWidget> on State<T> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _speechEnabled = false;

  bool get isListening => _isListening;
  bool get speechEnabled => _speechEnabled;

  Future<void> initializeSpeech() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        _showPermissionDeniedDialog();
        return;
      }

      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
            _showErrorDialog('Speech recognition error: ${error.errorMsg}');
          }
        },
        onStatus: (status) {
          if (mounted) {
            setState(() {
              _isListening = status == 'listening';
            });
          }
        },
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to initialize speech recognition: $e');
      }
    }
  }

  Future<void> startListening(Function(String) onResult) async {
    if (!_speechEnabled) {
      await initializeSpeech();
      if (!_speechEnabled) return;
    }

    if (_isListening) {
      await _speechToText.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
      return;
    }

    try {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
            if (mounted) {
              setState(() {
                _isListening = false;
              });
            }
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: false,
        localeId: 'en_US', // You can change this to support other languages
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      );

      if (mounted) {
        setState(() {
          _isListening = true;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to start listening: $e');
      }
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  void _showPermissionDeniedDialog() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Microphone Permission Required'),
          content: const Text(
            'This app needs microphone access to use voice search. Please enable microphone permission in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }
}