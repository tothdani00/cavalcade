// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cavalcade/core/constants/firebase_constants.dart';
import 'package:cavalcade/core/failure.dart';
import 'package:cavalcade/core/providers/firebase_providers.dart';
import 'package:cavalcade/core/type_defs.dart';
import 'package:cavalcade/models/community_model.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';


final communityRepoProvider = Provider((ref) {
  return CommunityRepo(firestore: ref.watch(firestoreProvider));
});

class CommunityRepo {
  final FirebaseFirestore _firestore;
  CommunityRepo({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try{
      var communityDoc = await _communities.doc(community.name).get();
      if(communityDoc.exists) {
        throw 'Ez a közösség már létezik!';
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch(e) {
      throw e.message!;
    } catch(e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid){
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for(var doc in event.docs){
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name){
    return _communities.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(Community community) async {
    try{
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch(e) {
      throw e.message!;
    } catch(e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String userID) async{
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayUnion([userID]),
        }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

    FutureVoid leaveCommunity(String communityName, String userID) async{
    try {
      return right(_communities.doc(communityName).update({
        'members': FieldValue.arrayRemove([userID]),
        }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query){
    return _communities.where('name', 
      isGreaterThanOrEqualTo: query.isEmpty ? 0 : query, 
      isLessThan: query.isEmpty ? null : query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1,
      )
    )
    .snapshots().map((event) {
        List<Community> communities = [];
        for(var community in event.docs) {
          communities.add(Community.fromMap(community.data() as Map<String, dynamic>));
        }
        return communities;
      }
    );
  }

  FutureVoid addAdmins(String communityName, List<String> uids) async {
    try{
      return right(_communities.doc(communityName).update({
        'admins': uids,
      }));
    } on FirebaseException catch(e) {
      throw e.message!;
    } catch(e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _posts
    .where('communityName', isEqualTo: name).orderBy('createdAt', descending: true)
    .snapshots()
    .map((event) => event.docs
    .map((e) => Post.fromMap(e.data() as Map<String, dynamic>),).toList(),);
  }

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);
}

