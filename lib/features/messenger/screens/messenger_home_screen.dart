import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/features/messenger/screens/messagages_screen.dart';
import 'package:cavalcade/responsive/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessengerHomeScreen extends ConsumerStatefulWidget {
  const MessengerHomeScreen({super.key});

  @override
  _MessengerHomeScreenState createState() => _MessengerHomeScreenState();
}

class _MessengerHomeScreenState extends ConsumerState<MessengerHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Üzenetek"),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(), 
      builder:(context, snapshot) {
        if(snapshot.hasError){
          return const Text("Error");
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

   if (_auth.currentUser != null && _auth.currentUser!.email != null && _auth.currentUser!.email != data['email']) {
      return Responsive(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
            leading: CircleAvatar(
            backgroundImage: NetworkImage(data['profilePicture']),
            ),
            title: Text(data['name']),
            onTap: () {
              Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => MessagesScreen(
                receiverUserEmail: data['email'],
                receiverUserUid: data['uid'], 
                ),
              ));
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
