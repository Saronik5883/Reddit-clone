import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  // http://localhost:4000/r/flutter

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var totalPosts = ref.watch(getCommunityPostsProvider(name));
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar.large(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Routemaster.of(context).pop(),
                ),
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                expandedHeight: 340,
                floating: true,
                snap: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //rounded corners
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(community.banner),
                            fit: BoxFit.cover,
                          ),
                        ),
                        margin: const EdgeInsets.only(left: 16, top: 120, right: 16),
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 20,
                            ),
                            const SizedBox(width: 10),
                             Text(
                              "r/${community.name}",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledButton.tonalIcon(
                              onPressed: (){},
                              icon: const Icon(Icons.people),
                              label: Text('${community.members.length}', ),
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            if (!isGuest)
                              community.mods.contains(user.uid)
                                  ? OutlinedButton(
                                onPressed: () {
                                  navigateToModTools(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                ),
                                child: const Text('Mod Tools'),
                              )
                                  : OutlinedButton(
                                onPressed: () => joinCommunity(ref, community, context),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                ),
                                child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join'),
                              ),
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
                    children: [
                      Row(
                        children: [
                          ref.watch(getCommunityPostsProvider(name)).when(
                            data: (data) {
                              return Text(
                                  '${data.length} Posts',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              return ErrorText(error: error.toString());
                            },
                            loading: () => const Loader(),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                              onPressed: (){
                                Routemaster.of(context).push('/add-post');
                              },
                              label: Text('New Post'),
                              icon: const Icon(Icons.add)
                          ),
                        ],
                     ),
                      const SizedBox(height: 5,),
                      const Divider(height: 10,)
                    ],
                  ),
                ),
              )
            ];
          },
          body: ref.watch(getCommunityPostsProvider(name)).when(
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