import 'package:cavalcade/features/auth/community/screens/admin_tools_screen.dart';
import 'package:cavalcade/features/auth/community/screens/create_community.dart';
import 'package:cavalcade/features/auth/community/screens/community_screen.dart';
import 'package:cavalcade/features/auth/community/screens/edit_community_screen.dart';
import 'package:cavalcade/features/auth/home/screens/home_screen.dart';
import 'package:cavalcade/features/auth/screens/login.dart';
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
}); 
