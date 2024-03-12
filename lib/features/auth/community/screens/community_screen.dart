// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/features/auth/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name,});


  void navigateToAdminTools(BuildContext context){
    Routemaster.of(context).push('/admin-tools/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameCommunitiesProvider(name))
      .when(
        data: (community) => NestedScrollView(headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 150,
              floating: true,
              snap: true,
              flexibleSpace: Stack(
                children:[
                  Positioned.fill(child: Image.asset(community.banner, fit: BoxFit.cover,),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(delegate: SliverChildListDelegate(
                [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(community.profilePic),
                      radius: 35,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        community.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      community.admins.contains(user.uid)
                      ? OutlinedButton(
                          onPressed: () { 
                            navigateToAdminTools(context);
                           }, 
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20)
                          ),
                          child: const Text('Admin beállítások'),
                        )
                      : OutlinedButton(
                        onPressed: () {}, 
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20)
                        ),
                        child: Text( community.members.contains(user.uid) ? 'Csatlakozva' : 'Csatlakozás'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '${community.members.length} tag', 
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      }, 
      body: const Text('Posztok')), 
      error: (error, stackTrace) => ErrorText(error: error.toString()), 
      loading: ()=> const Loader()),
    );
  }
}
