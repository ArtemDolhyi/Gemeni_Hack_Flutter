import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
import 'intro_screen.dart';

const String openAIAPIKey = 'YOUR_OPENAI_API_KEY'; // Add your OpenAI API key here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatModel(apiKey: openAIAPIKey),
      child: MaterialApp(
        title: 'OpenAI Chatbot',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IntroScreen(),  // Start with the IntroScreen
      ),
    );
  }
}
