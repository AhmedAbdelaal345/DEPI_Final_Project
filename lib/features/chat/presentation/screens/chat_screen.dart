import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_final_project/core/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../cubit/chat_cubit.dart';
import '../../cubit/chat_state.dart';
import '../../data/models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String studentId;
  final String teacherId;
  final String quizId;

  const ChatScreen({
    super.key,
    required this.studentId,
    required this.teacherId,
    required this.quizId,
  });

  static const String id = '/chat-screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String currentUserId;
    late String chatRoomId;

  String teacherName = 'Teacher';
  bool isLoadingTeacherName = true;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _fetchTeacherName();
    _initializeChat();
  }

  Future<void> _fetchTeacherName() async {
    try {
      final teacherDoc =
          await FirebaseFirestore.instance
              .collection(AppConstants.teacherCollection)
              .doc(widget.teacherId)
              .get();

      if (teacherDoc.exists) {
        final data = teacherDoc.data();
        setState(() {
          teacherName = data?['fullName'] ?? 'Teacher';
          isLoadingTeacherName = false;
        });
      } else {
        setState(() {
          isLoadingTeacherName = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingTeacherName = false;
      });
    }
  }

  void _initializeChat() {
    final cubit = context.read<ChatCubit>();
    cubit.initializeChatRoom(
      studentId: widget.studentId,
      teacherId: widget.teacherId,
      quizId: widget.quizId,
    );
    cubit.fetchMessages(widget.quizId); // Use quizId instead of chatRoomId
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(
      quizId: widget.quizId, // Use quizId
      text: text,
      senderId: currentUserId,
      studentId: widget.studentId,
      teacherId: widget.teacherId,
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C2B),
      appBar: AppBar(
        title:
            isLoadingTeacherName
                ? const Text('Loading...')
                : Text(
                  'Chat with $teacherName',
                  style: const TextStyle(color: Colors.white),
                ),
        backgroundColor: const Color(0xFF000920),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatMessageSent) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                }
                if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF5AC7C7)),
                  );
                }

                if (state is ChatLoaded) {
                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet. Start the conversation!',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return _buildMessageBubble(message);
                    },
                  );
                }

                return const Center(
                  child: Text(
                    'Start chatting!',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isMe = message.senderId == currentUserId;
    final time = _formatTimestamp(message.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF5AC7C7) : const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.white.withAlpha(153),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF000920),
        border: Border(top: BorderSide(color: Color(0xFF2A2D3E), width: 1)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                  filled: true,
                  fillColor: const Color(0xFF2A2D3E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF5AC7C7),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    if (timestamp is Timestamp) {
      final dateTime = timestamp.toDate();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        return DateFormat('HH:mm').format(dateTime);
      } else {
        return DateFormat('MMM dd, HH:mm').format(dateTime);
      }
    }
    return ''; // fallback لو مش Timestamp
  }
}
