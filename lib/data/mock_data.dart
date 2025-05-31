import 'package:uuid/uuid.dart';
import '../models/conversation.dart';
import '../models/message.dart';

const uuid = Uuid();

List<Conversation> mockConversations = [
  Conversation(
    id: '1',
    contactName: 'Ahmed Benani',
    lastMessage: 'Salut, ça va?',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 2,
  ),
  Conversation(
    id: '2',
    contactName: 'Fatima Alaoui',
    lastMessage: 'On peut se voir demain?',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    unreadCount: 0,
  ),
  Conversation(
    id: '3',
    contactName: 'Karim Tazi',
    lastMessage: 'Je t\'ai envoyé le document',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    unreadCount: 1,
  ),
  Conversation(
    id: '4',
    contactName: 'Leila Chaabi',
    lastMessage: 'Merci pour ton aide!',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    unreadCount: 0,
  ),
];

Map<String, List<Message>> mockMessages = {
  '1': [
    Message(
      id: uuid.v4(),
      conversationId: '1',
      content: 'Salam!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isFromMe: false,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '1',
      content: 'Salam Ahmed! Comment vas-tu?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isFromMe: true,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '1',
      content: 'Je vais bien, merci de demander!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      isFromMe: false,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '1',
      content: 'Tu as des plans pour ce weekend?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isFromMe: true,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '1',
      content: 'Pas encore, on pourrait se voir?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isFromMe: false,
    ),
  ],
  '2': [
    Message(
      id: uuid.v4(),
      conversationId: '2',
      content: 'Salam Fatima, tu es libre demain?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isFromMe: true,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '2',
      content: 'Oui, je devrais être libre après 14h',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      isFromMe: false,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '2',
      content: 'Parfait, on se retrouve au café?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      isFromMe: true,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '2',
      content: 'On peut se voir demain?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isFromMe: false,
    ),
  ],
  '3': [
    Message(
      id: uuid.v4(),
      conversationId: '3',
      content: 'Salut Karim, as-tu reçu mon e-mail?',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isFromMe: true,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '3',
      content: 'Oui, je le regarde maintenant',
      timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
      isFromMe: false,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '3',
      content: 'Je t\'ai envoyé le document',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isFromMe: false,
    ),
  ],
  '4': [
    Message(
      id: uuid.v4(),
      conversationId: '4',
      content: 'Leila, merci beaucoup pour ton aide avec le projet!',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      isFromMe: true,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '4',
      content: 'De rien! Je suis contente d\'avoir pu aider.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      isFromMe: false,
    ),
    Message(
      id: uuid.v4(),
      conversationId: '4',
      content: 'Merci pour ton aide!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isFromMe: false,
    ),
  ]
};

class MockDataService {
  static List<Conversation> getConversations() {
    return List.from(mockConversations);
  }

  static List<Message> getMessages(String conversationId) {
    return List.from(mockMessages[conversationId] ?? []);
  }

  static void addMessage(Message message) {
    if (mockMessages[message.conversationId] == null) {
      mockMessages[message.conversationId] = [];
    }
    mockMessages[message.conversationId]!.add(message);
    
    // Update the last message in the conversation
    final conversationIndex = mockConversations.indexWhere(
      (conv) => conv.id == message.conversationId,
    );
    
    if (conversationIndex != -1) {
      final conversation = mockConversations[conversationIndex];
      final updatedConversation = Conversation(
        id: conversation.id,
        contactName: conversation.contactName,
        lastMessage: message.content,
        timestamp: message.timestamp,
        unreadCount: message.isFromMe ? conversation.unreadCount : conversation.unreadCount + 1,
      );
      mockConversations[conversationIndex] = updatedConversation;
    }
  }
  
  static void resetUnreadCount(String conversationId) {
    final conversationIndex = mockConversations.indexWhere(
      (conv) => conv.id == conversationId,
    );
    
    if (conversationIndex != -1) {
      final conversation = mockConversations[conversationIndex];
      final updatedConversation = Conversation(
        id: conversation.id,
        contactName: conversation.contactName,
        lastMessage: conversation.lastMessage,
        timestamp: conversation.timestamp,
        unreadCount: 0,
      );
      mockConversations[conversationIndex] = updatedConversation;
    }
  }

  static void addConversation(Conversation conversation) {
    mockConversations.insert(0, conversation);
    // Initialize empty message list for the new conversation
    mockMessages[conversation.id] = [];
  }
}
