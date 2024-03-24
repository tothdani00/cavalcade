import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/features/auth/controller/community_controller.dart';
import 'package:cavalcade/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context){
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community){
    Routemaster.of(context).push('/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Közösség létrehozása'),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(data: (communities) => Expanded(
              child: ListView.builder(
                itemCount: communities.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = communities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(community.profilePic),
                    ),
                    title: Text(community.name),
                    onTap: () {
                      navigateToCommunity(context, community);
                    },
                  );
                },
              ),
            ), error: (error, StackTrace) => ErrorText(
            error: error.toString(),
          ), 
          loading: () =>  const Loader(),
        ),
      ],
    ),
  )
);
}
}

class RouteMaster {
}