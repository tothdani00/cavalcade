import 'package:cavalcade/features/auth/community/screens/create_community.dart';
import 'package:cavalcade/features/auth/home/screens/home_screen.dart';
import 'package:cavalcade/features/auth/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage<void>(child: Login()),
}); 

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage<void>(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
}); 
