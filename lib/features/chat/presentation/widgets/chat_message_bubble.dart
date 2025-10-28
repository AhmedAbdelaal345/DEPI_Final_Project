import 'package:depi_final_project/features/home/presentation/widgets/app_constants.dart'; // ⬅️ لاستخدام AppColors
import 'package:flutter/material.dart';
import 'package:depi_final_project/core/constants/color_app.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String timestamp;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isSender,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isSender ? AppColors.teal : ColorApp.greyColor;
    final textColor = isSender ? AppColors.bg : ColorApp.whiteColor;

    final timeColor = isSender
        ? Colors.white70
        : textColor.withOpacity(0.7);

    return Column(
      crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
              isSender ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight:
              isSender ? const Radius.circular(0) : const Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          margin: const EdgeInsets.only(top: 4.0, bottom: 2.0),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            timestamp,
            style: TextStyle(
              color: timeColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
