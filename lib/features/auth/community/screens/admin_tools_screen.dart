// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class AdminToolsScreen extends StatelessWidget {
  final String name;
  const AdminToolsScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  void navigateToAdminTools(BuildContext context){
    Routemaster.of(context).push('/edit-comunity/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin beállítások'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator_sharp),
            title: const Text('Admin hozzáadása'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Közösség szerkesztése'),
            onTap: () => navigateToAdminTools(context),
          ),
        ],
      ),
    );
  }
}
