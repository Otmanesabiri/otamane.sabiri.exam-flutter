import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/mock_data.dart';
import '../../models/message.dart';
import '../../models/conversation.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final uuid = const Uuid();

  ConversationBloc() : super(ConversationInitial()) {
    print('🔹 Initializing ConversationBloc');
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<OpenConversation>(_onOpenConversation);
    on<CreateNewConversation>(_onCreateNewConversation);
  }

  void _onLoadConversations(LoadConversations event, Emitter<ConversationState> emit) {
    print('🔹 Loading conversations');
    emit(ConversationLoading());
    try {
      final conversations = MockDataService.getConversations();
      print('🔹 Conversations loaded: ${conversations.length} conversations');
      emit(ConversationsLoaded(conversations));
      print('🔹 ConversationsLoaded state emitted');
    } catch (e) {
      print('❌ Error loading conversations: ${e.toString()}');
      emit(ConversationError('Failed to load conversations: ${e.toString()}'));
    }
  }

  void _onLoadMessages(LoadMessages event, Emitter<ConversationState> emit) {
    print('🔹 Loading messages for conversation ID: ${event.conversationId}');
    // Only emit loading state if we don't already have messages for this conversation
    // to avoid flickering of loading indicator when switching conversations
    if (state is! MessagesLoaded || (state is MessagesLoaded && (state as MessagesLoaded).conversationId != event.conversationId)) {
      emit(ConversationLoading());
    }
    
    try {
      final messages = MockDataService.getMessages(event.conversationId);
      print('🔹 Messages loaded for ${event.conversationId}: ${messages.length} messages');
      
      // Sort messages by timestamp to ensure correct order
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      emit(MessagesLoaded(messages, event.conversationId));
      print('🔹 MessagesLoaded state emitted for conversation: ${event.conversationId}');
    } catch (e) {
      print('❌ Error loading messages: ${e.toString()}');
      emit(ConversationError('Failed to load messages: ${e.toString()}'));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ConversationState> emit) {
    print('🔹 Sending message to conversation ID: ${event.conversationId}');
    print('🔹 Message content: ${event.content}');
    try {
      final message = Message(
        id: uuid.v4(),
        conversationId: event.conversationId,
        content: event.content,
        timestamp: DateTime.now(),
        isFromMe: true,
      );
      
      print('🔹 Adding message to mock data');
      MockDataService.addMessage(message);
      
      // Reload messages to show the new one
      print('🔹 Reloading messages');
      final messages = MockDataService.getMessages(event.conversationId);
      print('🔹 Messages loaded: ${messages.length} messages');
      emit(MessagesLoaded(messages, event.conversationId));
      print('🔹 MessagesLoaded state emitted');
      
      // Simulate receiving a response after a delay
      print('🔹 Simulating response');
      _simulateResponse(event.conversationId);
    } catch (e) {
      print('❌ Error sending message: ${e.toString()}');
      emit(ConversationError('Failed to send message: ${e.toString()}'));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ConversationState> emit) {
    try {
      MockDataService.addMessage(event.message);
      
      // Reload messages to show the new one
      final messages = MockDataService.getMessages(event.message.conversationId);
      emit(MessagesLoaded(messages, event.message.conversationId));
    } catch (e) {
      emit(ConversationError('Failed to receive message: ${e.toString()}'));
    }
  }

  void _onOpenConversation(OpenConversation event, Emitter<ConversationState> emit) {
    print('🔹 Opening conversation with ID: ${event.conversationId}');
    try {
      // Reset unread count when opening conversation
      print('🔹 Resetting unread count');
      MockDataService.resetUnreadCount(event.conversationId);
      
      // Load messages for this conversation
      print('🔹 Loading messages for conversation');
      final messages = MockDataService.getMessages(event.conversationId);
      print('🔹 Messages loaded: ${messages.length} messages');
      emit(MessagesLoaded(messages, event.conversationId));
      print('🔹 MessagesLoaded state emitted for conversation: ${event.conversationId}');
    } catch (e) {
      print('❌ Error opening conversation: ${e.toString()}');
      emit(ConversationError('Failed to open conversation: ${e.toString()}'));
    }
  }

  void _onCreateNewConversation(CreateNewConversation event, Emitter<ConversationState> emit) {
    print('🔹 Creating new conversation with contact: ${event.contactName}');
    try {
      final newConversation = Conversation(
        id: uuid.v4(),
        contactName: event.contactName,
        lastMessage: 'Nouvelle conversation créée',
        timestamp: DateTime.now(),
        unreadCount: 0,
      );
      
      print('🔹 Adding conversation to mock data');
      MockDataService.addConversation(newConversation);
      
      // Reload conversations to show the new one
      print('🔹 Reloading conversations');
      final conversations = MockDataService.getConversations();
      print('🔹 Conversations loaded: ${conversations.length} conversations');
      emit(ConversationsLoaded(conversations));
      print('🔹 ConversationsLoaded state emitted');
    } catch (e) {
      print('❌ Error creating conversation: ${e.toString()}');
      emit(ConversationError('Failed to create conversation: ${e.toString()}'));
    }
  }

  void _simulateResponse(String conversationId) {
    // Simulate a delay before receiving a response
    Future.delayed(const Duration(seconds: 2), () {
      final responses = [
        'Shukran pour ton message!',
        'Je te réponds bientôt insha\'Allah.',
        'C\'est noté, habibi!',
        'Parfait, bien reçu!',
        'Merci de m\'avoir contacté, à bientôt!',
      ];
      
      final randomResponse = responses[DateTime.now().millisecond % responses.length];
      
      final responseMessage = Message(
        id: uuid.v4(),
        conversationId: conversationId,
        content: randomResponse,
        timestamp: DateTime.now(),
        isFromMe: false,
      );
      
      add(ReceiveMessage(responseMessage));
    });
  }
}
