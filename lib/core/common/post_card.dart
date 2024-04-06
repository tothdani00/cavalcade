import 'package:any_link_preview/any_link_preview.dart';
import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/core/constants/constants.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/auth/controller/community_controller.dart';
import 'package:cavalcade/features/posts/controller/post_controller.dart';
import 'package:cavalcade/models/post_model.dart';
import 'package:cavalcade/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(BuildContext context, WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext context) async{
    Routemaster.of(context).push('/user/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) async{
    Routemaster.of(context).push(post.communityName);
  }

  void navigateToComments(BuildContext context) async{
    Routemaster.of(context).push('/posts/${post.id}/comments');
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref.read(postControllerProvider.notifier).awardPost(post: post, award: award, context: context);
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage : NetworkImage(
                                        post.communityProfilePic
                                        ),
                                        radius: 16,
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(post.communityName, 
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => navigateToUser(context),
                                        child: Text(post.userName, 
                                        style: const TextStyle(
                                          fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ),
                                ],
                              ),
                              if(post.uid == user.uid)
                                    IconButton(
                                    onPressed: () => deletePost(context, ref), 
                                    icon: Icon(
                                      Icons.delete, 
                                      color: Pallete.redColor
                                    ),
                                  ),
                            ],
                          ),
                          if(post.awards.isNotEmpty) ...[
                            const SizedBox(height: 5,),
                              Wrap(
                              spacing: 5, 
                              runSpacing: 5, 
                              children: List.generate(
                                post.awards.length,
                                (index) {
                                  final award = post.awards[index];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 50,
                                  );
                                },
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              post.title, 
                              style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if(isTypeImage)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: double.infinity,
                            child: Image.network(
                              post.link!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if(isTypeLink)
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: AnyLinkPreview(
                              displayDirection: UIDirection.uiDirectionHorizontal,
                              link: post.link!,
                            ),
                          ),
                          if(isTypeText)
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              post.description!, 
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(onPressed: () => upvotePost(ref), 
                                  icon: Icon(
                                    Constants.up,
                                    size: 30,
                                    color: post.upvotes.contains(user.uid)? Pallete.redColor : null,
                                    ),
                                  ),
                                  Text('${post.upvotes.length - post.downvotes.length == 0 ? 'Szavazás' : post.upvotes.length - post.downvotes.length}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  IconButton(onPressed: () => downvotePost(ref), 
                                  icon: Icon(
                                    Constants.down,
                                    size: 30,
                                    color: post.downvotes.contains(user.uid)? Pallete.blueColor : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(onPressed: () => navigateToComments(context), 
                                  icon: const Icon(
                                    Icons.comment,
                                    ),
                                  ),
                                  Text('${post.commentCount == 0 ? 'Komment' : post.commentCount}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              ref.watch(getCommunityByNameCommunitiesProvider(post.communityName)).when(
                                data: (data) {
                                if(data.admins.contains(user.uid)){
                                  return IconButton(onPressed: () => deletePost(context, ref), 
                                  icon: const Icon(
                                    Icons.admin_panel_settings_sharp,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              }, error: (error, stackTrace) => ErrorText(error: error.toString()), loading: () => const Loader(),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                  context: context, 
                                  builder: (context) => Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                            ),
                                          itemCount: user.awards.length,
                                          itemBuilder: (BuildContext context, int index) {
                                          final award = user.awards[index];
                                          return GestureDetector(
                                            onTap: () => awardPost(ref, award, context),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Image.asset(Constants.awards[award]!),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                                }, 
                                icon: const Icon(Icons.card_giftcard),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}