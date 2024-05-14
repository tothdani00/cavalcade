import 'package:cavalcade/models/message_model.dart';
import 'package:cavalcade/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId, 
      senderEmail: currentUserEmail, 
      receiverId: receiverId, 
      message: message, 
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    await _firestore.collection('chatRooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  Future<UserModel?> getUserData(String userId) async {
  try {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      UserModel user = UserModel(
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        profilePicture: userData['profilePicture'] ?? '',
        banner: userData['banner'] ?? '',
        uid: userData['uid'] ?? '', 
        isAuthenticated: userData['isAuthenticated'] ?? false,
        points: userData['points'] ?? 0,
        awards: List<String>.from(userData['awards'] ?? []),
      );
      return user;
    } else {
      return null;
    }
  } catch (e) {
    print('Hiba történt a felhasználó adatok lekérése közben: $e');
    return null;
  }
}


  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
    .collection('chatRooms')
    .doc(chatRoomId)
    .collection('messages')
    .orderBy('timestamp', descending: false)
    .snapshots();
  }
}