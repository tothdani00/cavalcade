import 'dart:io';
import 'dart:typed_data';
import 'package:cavalcade/core/enums/enums.dart';
import 'package:cavalcade/core/providers/storage_repo_provider.dart';
import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/posts/repo/post_repo.dart';
import 'package:cavalcade/features/user_profile/controller/user_profile_controller.dart';
import 'package:cavalcade/models/comment_model.dart';
import 'package:cavalcade/models/comment_reply_model.dart';
import 'package:cavalcade/models/community_model.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

final userPostsProvider = StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final guestPostsProvider = StreamProvider((ref,) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPosts();
});

final getPostsByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

final getCommentRepliesProvider = StreamProvider.family((ref, String commentId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchCommentReplies(commentId);
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
        _ref.read(userProfileControllerProvider.notifier).updateUserPoints(UserPoints.textPost);
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
        _ref.read(userProfileControllerProvider.notifier).updateUserPoints(UserPoints.linkPost);
        state = false;
        res.fold((l) => showSnackBar(context, l.message), 
        (r) {
          showSnackBar(context, 'Sikeres posztolás!');
          Routemaster.of(context).pop();
        });
    }


    void shareImagePost({required BuildContext context, required String title, required Community selectedCommunity, required File? file, required Uint8List? webFile}) async {
      state = true;
      String postId = const Uuid().v1();
      final user = _ref.read(userProvider);
      final imageRes = await _storageRepo.storeFile(path: 'posts/${selectedCommunity.name}', id: postId, file: file, webFile: webFile);

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
        type: 'image', 
        createdAt: DateTime.now(), 
        awards: [],
        link: r,
        );

        final res = await _postRepo.addPost(post);
        _ref.read(userProfileControllerProvider.notifier).updateUserPoints(UserPoints.imagePost);
        state = false;
        res.fold((l) => showSnackBar(context, l.message), 
        (r) {
          showSnackBar(context, 'Sikeres posztolás!');
          Routemaster.of(context).pop();
        });
      });
    }

    Stream<List<Post>> fetchUserPosts(List<Community> communities){
      if(communities.isNotEmpty) {
        return _postRepo.fetchUserPosts(communities);
      }
      return Stream.value([]);
    }

    Stream<List<Post>> fetchGuestPosts(){
      return _postRepo.fetchGuestPosts();
    }

    void deletePost(BuildContext context, Post post) async{
      final res = await _postRepo.deletePost(post);
      _ref.read(userProfileControllerProvider.notifier).updateUserPoints(UserPoints.deletePost);
      res.fold((l) => l.message, (r) => showSnackBar(context, 'Sikeres poszt törlés!'));
    }

    void upvote(Post post) async{
      final userid = _ref.read(userProvider)!.uid;
      _postRepo.upvote(post, userid);
    }

     void downvote(Post post) async{
      final userid = _ref.read(userProvider)!.uid;
      _postRepo.downvote(post, userid);
    }

    Stream<Post> getPostById(String postId) {
      return _postRepo.getPostById(postId);
    }

    void addComment({
      required BuildContext context, 
      required String text,
      required Post post,
      }) async{
      final user = _ref.read(userProvider)!;
      String commentId = const Uuid().v1();
      Comment comment = Comment(
        id: commentId, 
        text: text, 
        createdAt: DateTime.now(), 
        postId: post.id, 
        username: user.name, 
        profilePic: user.profilePicture,
      );
      final res = await _postRepo.addComment(comment);
      _ref.read(userProfileControllerProvider.notifier).updateUserPoints(UserPoints.comment);
      res.fold((l) => showSnackBar(context, l.message), (r) => null);
    }

    void addReply({
      required BuildContext context,
      required String text,
      required Post post,
      required String parentCommentId,
      }) async {
      final user = _ref.read(userProvider)!;
      String replyId = const Uuid().v1();
      Reply reply = Reply(
        id: replyId,
        text: text,
        createdAt: DateTime.now(),  
        postId: post.id,
        username: user.name,
        profilePic: user.profilePicture,
        parentCommentId: parentCommentId,
      );
      final res = await _postRepo.addReply(reply);
      _ref.read(userProfileControllerProvider.notifier).updateUserPoints(UserPoints.comment);
      res.fold((l) => showSnackBar(context, l.message), (r) => null);
    }   

    
    Stream<List<Comment>> fetchPostComments(String postId){
      return _postRepo.getCommentsOfPost(postId);
    }

    Stream<List<Comment>> fetchCommentReplies(String postId){
      return _postRepo.getCommentReplies(postId);
    }



    void awardPost({required Post post, required String award, required BuildContext context}) async{
      final user = _ref.read(userProvider)!;
      final res = await _postRepo.awardPost(post, award, user.uid);
      res.fold((l) => showSnackBar(context, l.message), (r) {
        _ref.read(userProfileControllerProvider.notifier).updateUserPoints(UserPoints.awardPost);
        _ref.read(userProvider.notifier).update((state) {
          state?.awards.remove(award);
          return state;
        });
        Routemaster.of(context).pop();
      });
    }
}
