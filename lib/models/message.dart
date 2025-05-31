import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String conversationId;
  final String content;
  final DateTime timestamp;
  final bool isFromMe; // Keep only one property for sender identification

  const Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.timestamp,
    required this.isFromMe,
  });

  // If you have any factory methods or JSON serialization, update them as well:
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFromMe: json['isFromMe'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isFromMe': isFromMe,
    };
  }

  @override
  List<Object> get props => [id, conversationId, content, timestamp, isFromMe];
}
