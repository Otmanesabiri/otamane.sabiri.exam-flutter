import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/conversation/conversation_bloc.dart';
import '../bloc/conversation/conversation_event.dart';
import '../bloc/conversation/conversation_state.dart';
import '../models/conversation.dart';
import 'conversation_detail_screen.dart';
import 'package:intl/intl.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({Key? key}) : super(key: key);

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(LoadConversations());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state is ConversationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ConversationsLoaded) {
            return _buildConversationList(state.conversations);
          } else if (state is ConversationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is MessagesLoaded) {
            // If we've loaded messages, we still want to show the conversation list
            context.read<ConversationBloc>().add(LoadConversations());
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('No conversations available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewConversationDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildConversationList(List<Conversation> conversations) {
    if (conversations.isEmpty) {
      return const Center(child: Text('No conversations yet'));
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _buildConversationTile(conversation);
      },
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    final formatter = DateFormat.jm();
    final formattedTime = formatter.format(conversation.timestamp);
    
    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(conversation.contactName[0].toUpperCase()),
        ),
        title: Text(
          conversation.contactName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          conversation.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formattedTime,
              style: TextStyle(
                color: conversation.unreadCount > 0 ? Colors.blue : Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            if (conversation.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${conversation.unreadCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        onTap: () {
          // Ceci déclenche l'événement pour ouvrir la conversation et naviguer vers l'écran de détail
          context.read<ConversationBloc>().add(OpenConversation(conversation.id));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationDetailScreen(
                conversationId: conversation.id,
                contactName: conversation.contactName,
              ),
            ),
          ).then((_) {
            // Reload conversations when returning from details screen
            if (mounted) {
              context.read<ConversationBloc>().add(LoadConversations());
            }
          });
        },
      ),
    );
  }

  void _showNewConversationDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Nouvelle Conversation'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nom du contact',
              hintText: 'Entrez le nom du contact',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  context.read<ConversationBloc>().add(
                    CreateNewConversation(nameController.text.trim()),
                  );
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }
}
