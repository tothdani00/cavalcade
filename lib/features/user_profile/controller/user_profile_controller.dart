import 'dart:io';
import 'package:cavalcade/core/enums/enums.dart';
import 'package:cavalcade/core/providers/storage_repo_provider.dart';
import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/user_profile/repos/user_profile_repo.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:cavalcade/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';


final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepo = ref.watch(userRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return UserProfileController(
    userProfileRepo: userProfileRepo,
    storageRepo: storageRepo,
    ref: ref,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});


class UserProfileController extends StateNotifier<bool>{
  final UserProfileRepo _userProfileRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;
  UserProfileController({
    required UserProfileRepo userProfileRepo, required Ref ref, required StorageRepo storageRepo,
    })
      : _userProfileRepo = userProfileRepo,
      _ref = ref,
      _storageRepo = storageRepo,
      super(false);


      void editCommunity({required File? profileFile, required File? bannerFile, required BuildContext context, required String name}) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if(profileFile != null){
      final res = await _storageRepo.storeFile(
        path: 'user/profile', 
        id: user.uid, 
        file: profileFile,
      );
      res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => user = user.copyWith(profilePicture: r),
      );
    }

    if(bannerFile != null){
      final res = await _storageRepo.storeFile(
        path: 'user/banner', 
        id: user.uid, 
        file: bannerFile,
      );
      res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) => user = user.copyWith(banner: r),
      );
    }
    user = user.copyWith(name: name);
    final res = await _userProfileRepo.editProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message), 
      (r) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(context).pop();
        },
      );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepo.getUserPosts(uid);
  }

  void updateUserPoints(UserPoints points) async{
    UserModel user = _ref.read(userProvider)!;
    if (user.points >= 0) {
    user = user.copyWith(points: user.points + points.points);

    final res = await _userProfileRepo.updateUserPoints(user);
    res.fold((l) => null, (r) => _ref.read(userProvider.notifier).update((state) => user));
    }
  }
}