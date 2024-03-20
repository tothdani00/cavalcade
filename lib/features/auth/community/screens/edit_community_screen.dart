import 'dart:io';
import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/core/constants/constants.dart';
import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/controller/community_controller.dart';
import 'package:cavalcade/theme/pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async{
    final res = await pickImage();
    if(res != null){
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async{
    final res = await pickImage();
    if(res != null){
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameCommunitiesProvider(widget.name)).when(data: (community) => Scaffold(
      backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Közösség szerkesztése'),
        centerTitle: false,
        actions: [
          TextButton(onPressed: () {}, 
          child: const Text('Mentés')
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: selectBannerImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10,4],
                      strokeCap: StrokeCap.round,
                      color: Pallete.darkModeAppTheme.textTheme.bodyText2!.color!,
                      child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        ),
                        child: bannerFile!= null ? Image.file(bannerFile!) : 
                        community.banner.isEmpty || community.banner == Constants.communityDefaultBannerPath ?
                        const Center(
                          child: Icon(Icons.camera_alt_outlined, size: 40,),
                        ): Image.asset(community.banner),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: selectProfileImage,
                      child: profileFile!=null 
                      ? CircleAvatar(
                        backgroundImage: FileImage(profileFile!),
                        radius: 30,
                        )
                      : CircleAvatar(
                        backgroundImage: AssetImage(Constants.communityDefaultPicturePath),
                        radius: 30,
                        ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    loading: () => const Loader(),
    error: (error, stackTrace) => ErrorText(error: error.toString(),
    ),
  );  
}
}