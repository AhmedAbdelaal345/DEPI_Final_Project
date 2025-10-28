import 'package:flutter/material.dart';
import 'package:depi_final_project/core/widgets/custom_app_bar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/message_input_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar(
        title: 'Mr. Ahmed',
        showBackButton: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                ChatMessageBubble(
                  text: 'Hello professor, I have a question.',
                  isSender: true,
                  timestamp: '4:50 PM',
                ),
                ChatMessageBubble(
                  text: 'Hello, go ahead.',
                  isSender: false,
                  timestamp: '4:51 PM',
                ),
                ChatMessageBubble(
                  text: 'How can I solve problem number 5 in the homework?',
                  isSender: true,
                  timestamp: '4:52 PM',
                ),
                ChatMessageBubble(
                  text: 'We will need to use the Pythagorean theorem. Can you remind me of the problem text?',
                  isSender: false,
                  timestamp: '4:53 PM',
                ),
              ],
            ),
          ),

          const MessageInputField(),
        ],
      ),
    );
  }
}

