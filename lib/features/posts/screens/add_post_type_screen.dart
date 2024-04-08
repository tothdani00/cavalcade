import 'dart:io';

import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/controller/community_controller.dart';
import 'package:cavalcade/features/posts/controller/post_controller.dart';
import 'package:cavalcade/models/community_model.dart';
import 'package:cavalcade/responsive/responsive.dart';
import 'package:cavalcade/theme/pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  Uint8List? bannerWebFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async{
  final res = await pickImage();
  if(res != null){
    if(kIsWeb){
      setState(() {
        bannerWebFile = res.files.first.bytes;
      });
    } else {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }
}

  void sharePost() {
    if(widget.type == 'image' && (bannerFile!=null || bannerWebFile != null) && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier)
      .shareImagePost(
        context: context, 
        title: titleController.text.trim(), 
        selectedCommunity: selectedCommunity ?? communities[0], 
        file: bannerFile,
        webFile: bannerWebFile,
      );
    } else if(widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier)
      .shareTextPost(
        context: context, 
        title: titleController.text.trim(), 
        selectedCommunity: selectedCommunity ?? communities[0], 
        description: descriptionController.text.trim(),
      );
    } else if(widget.type == 'link' && linkController.text.isNotEmpty && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier)
      .shareLinkPost(
        context: context, 
        title: titleController.text.trim(), 
        selectedCommunity: selectedCommunity ?? communities[0], 
        link: linkController.text.trim(),
      );
    } else {
      showSnackBar(context, 'Kérem töltse ki az összes mezőt!');
    }
  }

  @override
   Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
  appBar: AppBar(
    title: Text('Post ${widget.type}'),
    actions: [
      TextButton(
        onPressed: sharePost, 
        child: const Text('Megosztás'),
      ),
    ],
  ),
  body: isLoading ? const Loader() : SingleChildScrollView(
    child: Responsive(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Cím megadása',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
              maxLength: 30,
            ),
            const SizedBox(height: 10),
            if(isTypeImage) 
              GestureDetector(
                onTap: selectBannerImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10,4],
                  strokeCap: StrokeCap.round,
                  color: currentTheme.textTheme.bodyText2!.color!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: bannerWebFile !=null 
                    ? Image.memory(bannerWebFile!) 
                    : bannerFile!= null 
                      ? Image.file(bannerFile!) 
                      : const Center(
                        child: Icon(
                          Icons.camera_alt_outlined, 
                          size: 40,
                        ),
                    ),
                  ),
                ),
              ),
            if(isTypeText)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Leírás megadása',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            if(isTypeLink)
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Link megadása',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.topLeft, 
              child: Text('Válaszd ki a közösséget!'),
            ),
            ref.watch(userCommunitiesProvider).when(
              data: (data) {
                communities = data;
                if(data.isEmpty){
                  return const SizedBox();
                }
                return DropdownButton(
                  isExpanded: true,
                  value: selectedCommunity ?? data[0],
                  items: data.map((e) => DropdownMenuItem(value: e, 
                    child: Text(e.name))).toList(), 
                  onChanged: (val) {
                    setState(() {
                      selectedCommunity = val;
                    });
                  },
                );
              }, 
              error: (error, stackTrace) => ErrorText(error: error.toString()), 
              loading: () => const Loader(),
            ),
          ],
        ),
      ),
    ),
  ),
);
}
}