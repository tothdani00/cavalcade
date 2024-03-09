import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/features/auth/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier)
    .createCommunity(
      communityNameController.text.trim(),
       context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Közösség létrehozása'),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 18),
      ),
      body: isLoading
      ? const Loader()
      : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
            alignment: Alignment.topLeft, 
            child: Text('Közösség neve')
            ),
            const SizedBox(height: 10),
            TextField(
              controller: communityNameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Közösség neve',
                filled: true,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: createCommunity,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
              'Közösség létrehozása',
               style: TextStyle(fontSize: 15),
               ),
            ),
          ],
        ),
      ),
    );
  }
}