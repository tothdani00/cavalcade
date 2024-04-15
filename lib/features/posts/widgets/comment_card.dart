import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/posts/controller/post_controller.dart';
import 'package:cavalcade/models/comment_model.dart';
import 'package:cavalcade/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentCard extends ConsumerStatefulWidget {
  final Comment comment;
  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  bool showReplyBox = false;
  final replyController = TextEditingController();

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  void addReply(String postId, String parentId) {
    ref.read(getPostsByIdProvider(postId)).when(
      data: (post) {
        ref.read(postControllerProvider.notifier).addReply(
          context: context,
          text: replyController.text.trim(),
          post: post,
          parentCommentId: parentId,
        );
        setState(() {
          replyController.text = '';
          showReplyBox = false;
        });
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }

  @override
Widget build(BuildContext context) {
  final user = ref.watch(userProvider)!;
  final isGuest = !user.isAuthenticated;
    return Responsive(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.comment.profilePic),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.comment.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.comment.text),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      showReplyBox = !showReplyBox;
                    });
                  },
                  icon: const Icon(Icons.reply),
                ),
                const Text('Válasz'),
              ],
            ),
             if (showReplyBox && !isGuest)
              Container(
                margin: const EdgeInsets.only(left: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: replyController,
                      decoration: const InputDecoration(
                        hintText: 'Válasz',
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showReplyBox = false;
                        });
                        addReply(widget.comment.postId, widget.comment.id);
                      },
                      child: const Text('Válasz küldése'),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ref.watch(getCommentRepliesProvider(widget.comment.id)).when(
                data: (replies) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: replies.length,
                    itemBuilder: (BuildContext context, int index) {
                      final reply = replies[index];
                      return CommentCard(comment: reply);
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}