import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/auth/home/delegates/search_community.dart';
import 'package:cavalcade/features/auth/home/drawers/community_drawer.dart';
import 'package:cavalcade/features/auth/home/drawers/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Főoldal',
        style: TextStyle(fontSize: 20)),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunity(ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePicture),
                  radius: 17,
                ),
                onPressed: () => displayEndDrawer(context),
              );
            }
          ),
        ],
      ),
      drawer: const CommunityDrawer(),
      endDrawer: const ProfileDrawer(),
    );
  }
}