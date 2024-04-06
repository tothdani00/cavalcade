import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/core/common/post_card.dart';
import 'package:cavalcade/features/posts/controller/post_controller.dart';
import 'package:cavalcade/features/posts/widgets/comment_card.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post){
    ref.read(postControllerProvider.notifier).addComment(context: context, text: commentController.text.trim(), post: post);
    setState(() {
      commentController.text = '';  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostsByIdProvider(widget.postId)).when(data: (data) {
          return Column(
            children: [
              PostCard(post: data),
              TextField(
              onSubmitted: (val) => addComment(data),
              controller: commentController,
              decoration: const InputDecoration(
              hintText: 'Mi jár a fejedben?',
              filled: true,
              border: InputBorder.none,
              ),
            ),
            ref.watch(getPostCommentsProvider(widget.postId)).when(data: (data) {
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final comment = data[index];
                    return CommentCard(comment: comment);
                  },
                ),
              );
            }, 
            error: (error, stackTrace) => ErrorText(error: error.toString()
          ),
          loading: () =>  const Loader()),
          ],
        );
      }, 
      error: (error, stackTrace) => ErrorText(error: error.toString(),
      ), 
      loading: () =>  const Loader()),
    );
  }
}