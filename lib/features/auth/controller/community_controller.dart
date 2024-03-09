import 'package:cavalcade/core/constants/constants.dart';
import 'package:cavalcade/core/utils.dart';
import 'package:cavalcade/features/auth/community/repository/community_repo.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepo = ref.watch(communityRepoProvider);
  return CommunityController(
    communityRepository: communityRepo,
    ref: ref,
  );
});

class CommunityController extends StateNotifier<bool>{
  final CommunityRepo _communityRepository;
  final Ref _ref;
  CommunityController({
    required CommunityRepo communityRepository, required Ref ref,
    })
      : _communityRepository = communityRepository,
      _ref = ref,
      super(false);


  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name, 
      name: name, 
      banner: Constants.bannerPath, 
      profilePic: Constants.profilePicturePath, 
      members: [uid], 
      admins: [uid],
      );
      
      final res = await _communityRepository.createCommunity(community);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Közösség létrehozva!');
        Routemaster.of(context).pop();
      });
  }
}

