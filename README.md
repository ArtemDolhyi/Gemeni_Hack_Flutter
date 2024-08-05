# Flutter Experiments for Google Gemini Hackathon

## Overview

This repository is dedicated to exploring the capabilities of Flutter as part of our preparation for the Google Gemini Hackathon. While our team is developing a separate model that will leverage Google's Gemini API, this repository is specifically focused on experimenting with various features in Flutter. Our current work involves integrating and testing the OpenAI API to assess how Flutter handles dynamic interactions, ensures responsive design, and manages API integration.

## Features

- **Flutter UI Experiments:** Exploring the flexibility and capabilities of Flutter for building interactive and responsive user interfaces.
- **Dynamic Quick Replies:** Testing quick reply buttons that adapt based on the conversation context to enhance user interaction.
- **AI-Powered Responses:** Integrating the OpenAI API to generate intelligent, context-aware responses, and evaluating its potential for future use with the Gemini API.
- **Image Handling:** Experimenting with image upload and display within the chat interface to assess Flutter's multimedia capabilities.
- **Responsive Design:** Ensuring that the chatbot interface operates smoothly and responsively across various web platforms.

## Current Issues

1. **Environment Variables:** The current approach to loading environment variables using `.env` is not functioning as expected, which may impact the handling of API keys and other sensitive data.
2. **Image Display:** While image uploads are functional, they are not displaying correctly within the chat interface. Placeholders are currently being used as a temporary solution.
3. **Static Quick Replies:** The quick reply buttons are not dynamically updating based on the conversation context, limiting the chatbot's interactivity.


## Getting Started

## Prerequisites

- Flutter SDK
- Dart SDK
- OpenAI API Key
- A computer with macOS, Linux, or Windows

## Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/YourUsername/flutter-gemini-hackathon.git
    cd flutter-gemini-hackathon
    ```

2. **Install dependencies:**

    ```bash
    flutter pub get
    ```

3. **Run the project:**

    - For Web:
    
      ```bash
      flutter run -d chrome
      ```

    - For Mobile:

      ```bash
      flutter run
      ```

## Configuration

1. **OpenAI API Key:**
   
   Replace the placeholder API key in `main.dart` with your actual OpenAI API key.

   ```dart
   const String openAIAPIKey = 'your-openai-api-key';

### Key Files:
```graphql
lib/
├── chat_model.dart         # Handles the logic for interacting with OpenAI API and managing chat state
├── chat_screen.dart        # Contains the main chat UI, including message display and input handling
├── intro_screen.dart       # Displays the introductory screen with a start button
├── main.dart               # Entry point of the app, initializes the app and sets up providers
```

### Usage

- **Start the Chat:** Upon launching the app, you'll see an intro screen with a "Start" button. Clicking it takes you to the chat interface.
- **Send a Message:** Type your message in the input field and press "Enter" or click the send icon.
- **Quick Replies:** Tap on any of the quick reply buttons above the input field to send a predefined message.
- **Upload an Image:** Click on the image icon to upload an image from your device. The chatbot will respond to the image.

### Contributions

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Create a new Pull Request.
