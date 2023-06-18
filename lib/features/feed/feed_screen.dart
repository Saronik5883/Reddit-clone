import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/post_card.dart';
import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../core/constants/constants.dart';
import '../home/delegates/search_community_delegate.dart';
import '../home/drawers/community_list_drawer.dart';
import '../home/drawers/profile_drawer.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({Key? key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {


  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
        data: (communities) => ref.watch(userPostsProvider(communities)).when(
          data: (data) {
            return Scaffold(
              drawer: const CommunityListDrawer(),
              endDrawer: isGuest ? const Text("Please login to continue") : const ProfileDrawer(),
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    automaticallyImplyLeading: false,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    pinned: true,
                    title: Row(
                      children: [
                        //circle avatar of the reddit logo
                        CircleAvatar(
                          //backgroundColor: Colors.transparent,
                          child: Image.asset(
                            Constants.logoPath,
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 8,),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    centerTitle: false,
                    leading: Builder(builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => displayDrawer(context),
                      );
                    }),
                    actions: <Widget>[
                      Container(),
                      IconButton(
                        onPressed: () {
                          showSearch(context: context, delegate: SearchCommunityDelegate(ref));
                        },
                        icon: const Icon(Icons.search),
                      ),
                      IconButton(
                          onPressed: () {
                            isGuest ? const Text("Please login to continue") : Routemaster.of(context).push('/add-post');
                          },
                          icon: const Icon(Icons.add)
                      ),
                      Builder(builder: (context) {
                        return IconButton(
                          icon: CircleAvatar(
                            foregroundImage: NetworkImage(user.profilePic),
                          ),
                          onPressed: () => displayEndDrawer(context),
                        );
                      }),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        final post = data[index];
                        return PostCard(post: post);
                      },
                      childCount: data.length,
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return ErrorText(
              error: error.toString(),
            );
          },
          loading: () => const Loader(),
        ),
        error: (error, stackTrace) => ErrorText(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      );
    }

    return ref.watch(userCommunitiesProvider).when(
      data: (communities) => ref.watch(guestPostsProvider).when(
        data: (data) {
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 20, bottom: 20),
                  title: Text(
                    'Feed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final post = data[index];
                    return PostCard(post: post);
                  },
                  childCount: data.length,
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return ErrorText(
            error: error.toString(),
          );
        },
        loading: () => const Loader(),
      ),
      error: (error, stackTrace) => ErrorText(
        error: error.toString(),
      ),
      loading: () => const Loader(),
    );
  }
}
