import 'package:cavalcade/core/constants/constants.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/auth/home/delegates/search_community.dart';
import 'package:cavalcade/features/auth/home/drawers/community_drawer.dart';
import 'package:cavalcade/features/auth/home/drawers/profile_drawer.dart';
import 'package:cavalcade/theme/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

  class _HomeScreenState extends ConsumerState<HomeScreen> {
    int _page = 0;

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
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
      body: Constants.tabWidgets[_page],
      drawer: const CommunityDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '',
          ),
        ],
        onTap: onPageChange,
        currentIndex: _page,
      ),
    );
  }
}
