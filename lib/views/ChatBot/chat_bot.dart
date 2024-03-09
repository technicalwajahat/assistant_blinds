import 'package:flutter/material.dart';

import '../../widgets/appBar.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBotScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(text: "ChatBot"),
    );
  }
}
