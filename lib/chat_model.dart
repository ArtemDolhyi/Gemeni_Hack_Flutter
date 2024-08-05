import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatModel with ChangeNotifier {
  final String apiKey;
  List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  List<String> _quickReplies = ["Hello!", "Tell me a joke", "What can you do?"]; // Initial quick replies

  ChatModel({required this.apiKey});

  List<Map<String, String>> get messages => _messages;
  bool get isTyping => _isTyping;
  
  // Add this getter for quickReplies
  List<String> get quickReplies => _quickReplies;

  Future<void> sendMessage(String message) async {
    _addMessage({"role": "user", "content": message});
    _setTyping(true);

    final response = await _sendRequestToOpenAI(message);

    _setTyping(false);

    if (response != null) {
      _addMessage({"role": "bot", "content": response});
      _updateQuickReplies(response); // Update quick replies based on the bot's response
    }
  }

  Future<void> sendQuickReply(String reply) async {
    sendMessage(reply);
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

  void _updateQuickReplies(String botResponse) {
    // Example logic to update quick replies based on bot's response. 
    // It's a shit, we should implement better solution. Right now it's just a placeholder
    if (botResponse.contains("joke")) {
      _quickReplies = ["Another joke?", "Tell me more", "Thanks!"];
    } else if (botResponse.contains("?")) {
      _quickReplies = ["Teel me about Roman Empire?", "What can you do?", "Thanks!"];
    } else {
      _quickReplies = ["Hello!", "Tell me a joke", "What can you do?"];
    }
    notifyListeners();
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _addMessage({"role": "user", "content": "[Image]", "imagePath": pickedFile.path});

      Future.delayed(Duration(seconds: 2), () {
        _addMessage({"role": "bot", "content": "Nice image! I'm using OpenAI API, so I can't assist you further with this image. When we will migrate to Gemini than I will be able to read it and understand it's content. In the mean time I can tell you some intresting facts about Roman Empire. Would you want to hear about it?"});
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
