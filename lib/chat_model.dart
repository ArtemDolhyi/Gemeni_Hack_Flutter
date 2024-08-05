// chat_model.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatModel with ChangeNotifier {
  final String apiKey;
  List<Map<String, String>> _messages = [];

  ChatModel({required this.apiKey});

  List<Map<String, String>> get messages => _messages;

  Future<void> sendMessage(String message) async {
    _messages.add({"role": "user", "content": message});
    notifyListeners();

    final response = await _sendRequestToOpenAI(message);

    if (response != null) {
      _messages.add({"role": "bot", "content": response});
      notifyListeners();
    }
  }

  Future<String?> _sendRequestToOpenAI(String prompt) async {
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'gpt-4', // Use 'gpt-3.5-turbo' or another model if necessary
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': prompt},
      ],
    });

    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      return 'Error: ${response.reasonPhrase}';
    }
  }
}
