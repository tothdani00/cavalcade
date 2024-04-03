import 'dart:io';
import 'package:cavalcade/core/providers/storage_repo_provider.dart';
import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/posts/repo/post_repo.dart';
import 'package:cavalcade/models/community_model.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider<postController, bool>((ref) {
  final postRepo = ref.watch(postRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return postController(
    postRepo: postRepo,
    storageRepo: storageRepo,
    ref: ref,
  );
});

class postController extends StateNotifier<bool>{
  final AddPostRepo _postRepo;
  final Ref _ref;
  final StorageRepo _storageRepo;
  postController({
    required AddPostRepo postRepo, required Ref ref, required StorageRepo storageRepo,
    })
      : _postRepo = postRepo,
      _ref = ref,
      _storageRepo = storageRepo,
      super(false);

    void shareTextPost({required BuildContext context, required String title, required Community selectedCommunity, required String description}) async {
      state = true;
      String postId = const Uuid().v1();
      final user = _ref.read(userProvider);
      final Post post = Post(
        id: postId, 
        title: title, 
        communityName: selectedCommunity.name, 
        communityProfilePic: selectedCommunity.profilePic, 
        upvotes: [], 
        downvotes: [], 
        commentCount: 0, 
        userName: user!.name, 
        uid: user.uid, 
        type: 'text', 
        createdAt: DateTime.now(), 
        awards: [],
        description: description,
        );

        final res = await _postRepo.addPost(post);
        state = false;
        res.fold((l) => showSnackBar(context, l.message), 
        (r) {
          showSnackBar(context, 'Sikeres posztolás!');
          Routemaster.of(context).pop();
        });
    }

    void shareLinkPost({required BuildContext context, required String title, required Community selectedCommunity, required String link}) async {
      state = true;
      String postId = const Uuid().v1();
      final user = _ref.read(userProvider);
      final Post post = Post(
        id: postId, 
        title: title, 
        communityName: selectedCommunity.name, 
        communityProfilePic: selectedCommunity.profilePic, 
        upvotes: [], 
        downvotes: [], 
        commentCount: 0, 
        userName: user!.name, 
        uid: user.uid, 
        type: 'link', 
        createdAt: DateTime.now(), 
        awards: [],
        link: link,
        );

        final res = await _postRepo.addPost(post);
        state = false;
        res.fold((l) => showSnackBar(context, l.message), 
        (r) {
          showSnackBar(context, 'Sikeres posztolás!');
          Routemaster.of(context).pop();
        });
    }


    void shareImagePost({required BuildContext context, required String title, required Community selectedCommunity, required File? file}) async {
      state = true;
      String postId = const Uuid().v1();
      final user = _ref.read(userProvider);
      final imageRes = await _storageRepo.storeFile(path: 'posts/${selectedCommunity.name}', id: postId, file: file);

      imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
        final Post post = Post(
        id: postId, 
        title: title, 
        communityName: selectedCommunity.name, 
        communityProfilePic: selectedCommunity.profilePic, 
        upvotes: [], 
        downvotes: [], 
        commentCount: 0, 
        userName: user!.name, 
        uid: user.uid, 
        type: 'link', 
        createdAt: DateTime.now(), 
        awards: [],
        link: r,
        );

        final res = await _postRepo.addPost(post);
        state = false;
        res.fold((l) => showSnackBar(context, l.message), 
        (r) {
          showSnackBar(context, 'Sikeres posztolás!');
          Routemaster.of(context).pop();
        });
      });
    }
}