import 'package:cavalcade/core/constants/firebase_constants.dart';
import 'package:cavalcade/core/failure.dart';
import 'package:cavalcade/core/providers/firebase_providers.dart';
import 'package:cavalcade/core/type_defs.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postRepoProvider = Provider((ref) {
  return AddPostRepo(firestore: ref.watch(firestoreProvider));
});

class AddPostRepo {
  final FirebaseFirestore _firestore;
  AddPostRepo({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async{
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}