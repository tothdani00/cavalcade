
import 'package:cavalcade/core/common/chat_bubble.dart';
import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/core/common/text_fields.dart';
import 'package:cavalcade/features/messenger/service/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserUid;
  const MessagesScreen({super.key, required this.receiverUserEmail, required this.receiverUserUid});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  late Stream _messageStream;

  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserUid, _messageController.text);
       _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _messageStream = _chatService.getMessages(widget.receiverUserUid, _auth.currentUser!.uid);
  }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privát üzenet"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _messageStream, 
      builder:(context, snapshot) {
        if(snapshot.hasError){
          return ErrorText(error: snapshot.error.toString());
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(snapshot.data!.docs[index]);
        },
      );
      },
    );
  }

    Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _auth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            chatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFields(
                controller: _messageController,
                hintText: 'Üzenet megadása...',
                obsText: false,
              ),
            ),
          ),
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward_outlined, size: 30))
        ],
      ),
    );
  }
}