import 'package:cavalcade/features/auth/community/screens/add_admin.dart';
import 'package:cavalcade/features/auth/community/screens/admin_tools_screen.dart';
import 'package:cavalcade/features/auth/community/screens/create_community.dart';
import 'package:cavalcade/features/auth/community/screens/community_screen.dart';
import 'package:cavalcade/features/auth/community/screens/edit_community_screen.dart';
import 'package:cavalcade/features/auth/home/screens/home_screen.dart';
import 'package:cavalcade/features/auth/screens/login.dart';
import 'package:cavalcade/features/posts/screens/add_post_type_screen.dart';
import 'package:cavalcade/features/user_profile/screens/edit_profile_screen.dart';
import 'package:cavalcade/features/user_profile/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: Login()),
}); 

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
  '/:name': (route) => MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!)),
  '/admin-tools/:name' : (routeData) => MaterialPage(child: AdminToolsScreen(name: routeData.pathParameters['name']!,)),
  '/edit-comunity/:name' : (routeData) => MaterialPage(child: EditCommunityScreen(name: routeData.pathParameters['name']!,)),
  '/add-admin/:name' : (routeData) => MaterialPage(child: AddAdmin(name: routeData.pathParameters['name']!,)),
  '/user/:uid' : (routeData) => MaterialPage(child: UserProfileScreen(uid: routeData.pathParameters['uid']!,)),
  '/edit-profile/:uid' : (routeData) => MaterialPage(child: EditProfileScreen(uid: routeData.pathParameters['uid']!,)),
  '/add-post/:type' : (routeData) => MaterialPage(child: AddPostTypeScreen(type: routeData.pathParameters['type']!,)),
}); 
