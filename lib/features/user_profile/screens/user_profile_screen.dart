import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/current_uid.dart';
import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
import 'package:reddit_tutorial/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar.large(
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    expandedHeight: 400,
                    floating: true,
                    snap: true,
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'r/${user.name}',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //rounded corners
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(user.banner),
                                fit: BoxFit.cover,
                              ),
                            ),
                            margin: const EdgeInsets.only(left: 16, top: 120, right: 16),
                            height: 150,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 35,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  "u/${user.name}",
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FilledButton.tonalIcon(
                                  onPressed: (){},
                                  icon: const Icon(Icons.local_fire_department_outlined),
                                  label: Text('${user.karma} karma', ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  ),
                                ),
                                      currentUserId == user.uid ? Container(
                                        alignment: Alignment.bottomLeft,
                                        //padding: const EdgeInsets.only(top: 20, left: 20),
                                        child: OutlinedButton(
                                          onPressed: () => navigateToEditUser(context),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 25),
                                          ),
                                          child: const Text('Edit Profile'),
                                        ),
                                      ) : Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Posts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          const Divider(height: 10,),
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: ref.watch(getUserPostsProvider(uid)).when(
                    data: (data) {
                      return MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
