import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/chat_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _messageSubscription;

  ChatCubit(this._chatRepository) : super(ChatInitial());

  void fetchMessages(String quizId) {
    emit(ChatLoading());
    _messageSubscription?.cancel();
    _messageSubscription = _chatRepository.getMessages(quizId).listen(
      (messages) {
        emit(ChatLoaded(messages));
      },
      onError: (error) {
        emit(ChatError('Failed to load messages: ${error.toString()}'));
      },
    );
  }

  Future<void> sendMessage({
    required String quizId,
    required String text,
    required String senderId,
    required String studentId,
    required String teacherId,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      await _chatRepository.sendMessage(
        text: text.trim(),
        senderId: senderId,
        studentId: studentId,
        teacherId: teacherId,
        quizId: quizId,
      );
    } catch (e) {
      emit(ChatError('Failed to send message: ${e.toString()}'));
    }
  }

  // Initialize chat room if it doesn't exist
  Future<void> initializeChatRoom({
    required String studentId,
    required String teacherId,
    required String quizId,
  }) async {
    try {
      final exists = await _chatRepository.chatRoomExists(quizId);
      if (!exists) {
        await _chatRepository.createChatRoom(
          studentId: studentId,
          teacherId: teacherId,
          quizId: quizId,
        );
      }
    } catch (e) {
      emit(ChatError('Failed to initialize chat room: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}