import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../models/community_model.dart';


class BrowseAllCommunities extends ConsumerWidget {
  const BrowseAllCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void navigateToCommunity(BuildContext context, Community community) {
      Routemaster.of(context).push('/r/${community.name}');
    }

    final communitiesAsyncValue = ref.watch(allCommunitiesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('All Communities'),
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return communitiesAsyncValue.when(
                  data: (communities) {
                    final community = communities[index];
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                      child: Card(
                        child: Container(
                          margin: const EdgeInsets.only(top:10),
                          child: ListTile(
                            onTap: () {
                              navigateToCommunity(context, community);
                            },
                            leading: CircleAvatar(
                              backgroundImage : NetworkImage(community.avatar),
                              radius: 30,
                            ),
                            title: Text(
                                'r/${community.name}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.group, size: 15),
                                const SizedBox(width: 5),
                                Text('${community.members.length} members'),
                              ],
                            ),

                          ),
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return const Loader();
                  },
                  error: (error, stackTrace) {
                    return Text('Error: $error');
                  },
                );
              },
              childCount: communitiesAsyncValue.when(
                data: (communities) => communities.length,
                loading: () => 0,
                error: (_, __) => 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}





