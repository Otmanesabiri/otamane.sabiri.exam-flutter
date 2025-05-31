import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/conversation/conversation_bloc.dart';
import '../bloc/conversation/conversation_event.dart';
import '../bloc/conversation/conversation_state.dart';
import '../models/message.dart';
import 'package:intl/intl.dart';

class ConversationDetailScreen extends StatefulWidget {
  final String conversationId;
  final String contactName;

  const ConversationDetailScreen({
    Key? key,
    required this.conversationId,
    required this.contactName,
  }) : super(key: key);

  @override
  State<ConversationDetailScreen> createState() => _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load messages for this conversation
    print('🚀 Detail Screen - Initializing for conversation ${widget.conversationId}');
    // First mark the conversation as opened to reset unread count
    context.read<ConversationBloc>().add(OpenConversation(widget.conversationId));
    // Then load messages
    context.read<ConversationBloc>().add(LoadMessages(widget.conversationId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🚀 Detail Screen - Building for conversation ${widget.conversationId}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Call functionality would go here')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call functionality would go here')),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ConversationBloc, ConversationState>(
        listener: (context, state) {
          print('⚡ ConversationDetailScreen - state received: ${state.runtimeType}');
          if (state is MessagesLoaded) {
            print('⚡ MessagesLoaded state - conversation ID: ${state.conversationId}, widget ID: ${widget.conversationId}');
            if (state.conversationId == widget.conversationId) {
              // Scroll to bottom when new messages are loaded
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
            }
          }
        },
        buildWhen: (previous, current) {
          // Only rebuild if the state is relevant to this screen
          if (current is MessagesLoaded) {
            return current.conversationId == widget.conversationId;
          }
          return current is ConversationLoading || current is ConversationError;
        },
        builder: (context, state) {
          print('⚡ ConversationDetailScreen building UI with state: ${state.runtimeType}');
          
          // If we have a MessagesLoaded state but for a different conversation, 
          // trigger a load for the current conversation
          if (state is MessagesLoaded && state.conversationId != widget.conversationId) {
            print('⚡ Got messages for different conversation, loading current conversation messages');
            // This will happen on first build so don't need to explicitly request
          }
          
          if (state is MessagesLoaded && state.conversationId == widget.conversationId) {
            print('⚡ Building messages UI with ${state.messages.length} messages');
            return Column(
              children: [
                Expanded(
                  child: _buildMessagesList(state.messages),
                ),
                _buildMessageInput(),
              ],
            );
          } else if (state is ConversationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            print('⚡ Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildMessagesList(List<Message> messages) {
    if (messages.isEmpty) {
      return const Center(child: Text('No messages yet'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.isFromMe;
        return _buildMessageBubble(message, isMe);
      },
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    final formatter = DateFormat.jm();
    final formattedTime = formatter.format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Text(
                widget.contactName[0].toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[300],
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attachment functionality would go here')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Tapez votre message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Camera functionality would go here')),
              );
            },
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<ConversationBloc>().add(
        SendMessage(
          conversationId: widget.conversationId,
          content: content,
        ),
      );
      _messageController.clear();
    }
  }
}
