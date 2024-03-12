// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cavalcade/core/constants/firebase_constants.dart';
import 'package:cavalcade/core/failure.dart';
import 'package:cavalcade/core/providers/firebase_providers.dart';
import 'package:cavalcade/core/type_defs.dart';
import 'package:cavalcade/models/community_model.dart';
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
  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);
}

