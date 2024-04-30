import "package:cavalcade/core/common/error_text.dart";
import "package:cavalcade/core/common/loader.dart";
import "package:cavalcade/features/auth/controller/auth_controller.dart";
import "package:cavalcade/features/auth/controller/community_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AddAdmin extends ConsumerStatefulWidget {
  final String name;
  const AddAdmin({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddAdminState();
}

class _AddAdminState extends ConsumerState<AddAdmin> {
  Set<String> uids = {};
  int counter = 0;

  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveAdmins() {
    ref.read(communityControllerProvider.notifier).addAdmins(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveAdmins,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameCommunitiesProvider(widget.name)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = community.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.admins.contains(member) && counter == 0) {
                          uids.add(member);
                        }
                        counter++;
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUids(user.uid);
                            } else {
                              removeUids(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}