import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatModel with ChangeNotifier {
  final String apiKey;
  List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  ChatModel({required this.apiKey});

  List<Map<String, String>> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String message) async {
    _addMessage({"role": "user", "content": message});
    _setTyping(true);

    final response = await _sendRequestToOpenAI(message);

    _setTyping(false);

    if (response != null) {
      _addMessage({"role": "bot", "content": response});
    }
  }

  Future<String?> _sendRequestToOpenAI(String prompt) async {
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-4',
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': prompt},
      ],
    });

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: Failed to connect to the server.';
    }
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Use `pickImage` instead of `getImage`

    if (pickedFile != null) {
      _addMessage({"role": "user", "content": "[Image]", "imagePath": pickedFile.path});

      // Simulate bot response after sending the image
      Future.delayed(Duration(seconds: 2), () {
        _addMessage({"role": "bot", "content": "Nice image! How can I assist you further?"});
      });
    }
  }

  void _addMessage(Map<String, String> message) {
    _messages.add(message);
    notifyListeners();
  }

  void _setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }
}
