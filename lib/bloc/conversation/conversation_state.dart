import 'package:equatable/equatable.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();
  
  @override
  List<Object> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationsLoaded extends ConversationState {
  final List<Conversation> conversations;

  const ConversationsLoaded(this.conversations);

  @override
  List<Object> get props => [conversations];
}

class ConversationError extends ConversationState {
  final String message;

  const ConversationError(this.message);

  @override
  List<Object> get props => [message];
}

class MessagesLoaded extends ConversationState {
  final List<Message> messages;
  final String conversationId;

  const MessagesLoaded(this.messages, this.conversationId);

  @override
  List<Object> get props => [messages, conversationId];
}

class MessageSent extends ConversationState {
  final Message message;

  const MessageSent(this.message);

  @override
  List<Object> get props => [message];
}
