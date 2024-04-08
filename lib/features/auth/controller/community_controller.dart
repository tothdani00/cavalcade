import 'dart:io';
import 'dart:typed_data';
import 'package:cavalcade/core/constants/constants.dart';
import 'package:cavalcade/core/failure.dart';
import 'package:cavalcade/core/providers/storage_repo_provider.dart';
import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/community/repository/community_repo.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/models/community_model.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameCommunitiesProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});


final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepo = ref.watch(communityRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return CommunityController(
    communityRepository: communityRepo,
    storageRepo: storageRepo,
    ref: ref,
  );
});

class CommunityController extends StateNotifier<bool>{
  final CommunityRepo _communityRepository;
  final Ref _ref;
  final StorageRepo _storageRepo;
  CommunityController({
    required CommunityRepo communityRepository, required Ref ref, required StorageRepo storageRepo,
    })
      : _communityRepository = communityRepository,
      _ref = ref,
      _storageRepo = storageRepo,
      super(false);


  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name, 
      name: name, 
      banner: Constants.communityDefaultBannerPath, 
      profilePic: Constants.communityDefaultPicturePath, 
      members: [uid], 
      admins: [uid],
      );
      
      final res = await _communityRepository.createCommunity(community);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Közösség létrehozva!');
        Routemaster.of(context).pop();
      });
  }
  Stream<List<Community>> getUserCommunities(){
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name){
    return _communityRepository.getCommunityByName(name);
  }

   void editCommunity({
    required File? profileFile, 
    required File? bannerFile,
    required Uint8List? profileWebFile, 
    required Uint8List? bannerWebFile,
    required BuildContext context, 
    required Community community
    }) async {
    state = true;
    if(profileFile != null || profileWebFile != null){
      final res = await _storageRepo.storeFile(
        path: 'communities/profile', 
        id: community.name, 
        file: profileFile,
        webFile: profileWebFile,
      );
      res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => community = community.copyWith(profilePic: r),
      );
    }

    if(bannerFile != null || bannerWebFile != null){
      final res = await _storageRepo.storeFile(
        path: 'communities/banner', 
        id: community.name, 
        file: bannerFile,
        webFile: bannerWebFile,
      );
      res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => community = community.copyWith(banner: r),
      );
    }
    
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => Routemaster.of(context).pop());
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;

    if(community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if(community.members.contains(user.uid)) {
        showSnackBar(context, 'Sikeres kilépés!');
      } else {
        showSnackBar(context, 'Sikeres csatlakozás!');
      }
    });
  }

  void addAdmins(String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addAdmins(communityName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }

}

