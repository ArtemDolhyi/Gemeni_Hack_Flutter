import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(BuildContext context) {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      Provider.of<ChatModel>(context, listen: false).sendMessage(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenAI Chatbot'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatModel>(
              builder: (context, chatModel, child) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: chatModel.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatModel.messages[chatModel.messages.length - 1 - index];
                          final isUserMessage = message['role'] == 'user';
                          return Align(
                            alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                color: isUserMessage ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: kIsWeb && message['imagePath'] != null
                                  ? Placeholder(
                                      fallbackHeight: 200.0,
                                      fallbackWidth: 300.0,
                                      color: Colors.grey,
                                      strokeWidth: 2.0,
                                    )
                                  : message['imagePath'] != null
                                      ? Image.file(File(message['imagePath']!))
                                      : Text(
                                          message['content']!,
                                          style: TextStyle(
                                            color: isUserMessage ? Colors.white : Colors.black,
                                          ),
                                        ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (chatModel.isTyping)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 8),
                            Text("Bot is typing..."),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () => Provider.of<ChatModel>(context, listen: false).sendImage(),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message',
                    ),
                    onSubmitted: (_) => _sendMessage(context), // Handle "Enter" key press
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
