import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/models/post_model.dart';
import 'package:reddit_tutorial/responsive/responsive.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref.read(postControllerProvider.notifier).awardPost(post: post, award: award, context: context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Responsive(
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb)
                  Column(
                    children: [
                      IconButton(
                        onPressed: isGuest ? () {} : () => upvotePost(ref),
                        icon: Icon(
                          Constants.up,
                          size: 30,
                          color: post.upvotes.contains(user.uid) ? Pallete.redColor : null,
                        ),
                      ),
                      Text(
                        '${post.upvotes.length - post.downvotes.length == 0 ? '0' : post.upvotes.length - post.downvotes.length}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      IconButton(
                        onPressed: isGuest ? () {} : () => downvotePost(ref),
                        icon: Icon(
                          Constants.down,
                          size: 30,
                          color: post.downvotes.contains(user.uid) ? Pallete.blueColor : null,
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: Column(
                    children: [
                        Container(
                          //color: Theme.of(context).colorScheme.surfaceVariant,
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => navigateToCommunity(context),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            post.communityProfilePic,
                                          ),
                                          radius: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'r/${post.communityName}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => navigateToUser(context),
                                              child: Text(
                                                'u/${post.username}',
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (post.uid == user.uid)
                                    IconButton.filledTonal(
                                      onPressed: () => deletePost(ref, context),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Pallete.redColor,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.5),
                                      ),
                                    ),
                                ],
                              ),
                              if (post.awards.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 25,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: post.awards.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final award = post.awards[index];
                                      return Image.asset(
                                        Constants.awards[award]!,
                                        height: 23,
                                      );
                                    },
                                  ),
                                ),
                              ],
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  post.title,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (isTypeImage)
                                Container(
                                  decoration: BoxDecoration(
                                    //color: Theme.of(context).colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(post.link!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  height: MediaQuery.of(context).size.height * 0.35,
                                  width: double.infinity,
                                ),
                              if (isTypeLink)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: AnyLinkPreview(
                                    displayDirection: UIDirection.uiDirectionHorizontal,
                                    link: post.link!,
                                  ),
                                ),
                              if (isTypeText)
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    post.description!,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!kIsWeb)
                                    FilledButton.tonal(
                                      onPressed: (){},
                                      style: FilledButton.styleFrom(
                                        backgroundColor: (post.upvotes.length - post.downvotes.length) == 0 ?
                                        Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
                                        : (post.upvotes.length - post.downvotes.length) > 0 ?
                                        Pallete.redColor.withOpacity(0.2) :
                                        Pallete.blueColor.withOpacity(0.2),
                                        //fixedSize: Size(150, 40),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: isGuest ? () {} : () => upvotePost(ref),
                                            child: Icon(
                                              Icons.keyboard_arrow_up_sharp,
                                              //size: 30,
                                              color: post.upvotes.contains(user.uid) ? Pallete.redColor : null,
                                            ),
                                          ),
                                          Text(
                                            '${post.upvotes.length - post.downvotes.length == 0 ? '0' : post.upvotes.length - post.downvotes.length}',
                                            style: const TextStyle(fontSize: 17),
                                          ),
                                          InkWell(
                                            onTap: isGuest ? () {} : () => downvotePost(ref),
                                            child: Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              //size: 30,
                                              color: post.downvotes.contains(user.uid) ? Pallete.blueColor : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      FilledButton.tonalIcon(
                                        onPressed: () => navigateToComments(context),
                                        icon: Icon(
                                          Icons.comment_rounded,
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        ),
                                        label: Text(
                                          '${post.commentCount == 0 ? '0' : post.commentCount}',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ),

                                    ],
                                  ),
                                  ref.watch(getCommunityByNameProvider(post.communityName)).when(
                                        data: (data) {
                                          if (data.mods.contains(user.uid)) {
                                            return IconButton.filledTonal(
                                              onPressed: () => deletePost(ref, context),
                                              icon: const Icon(
                                                Icons.admin_panel_settings,
                                              ),
                                              style: IconButton.styleFrom(
                                                backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.5),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                        error: (error, stackTrace) => ErrorText(
                                          error: error.toString(),
                                        ),
                                        loading: () => const Loader(),
                                      ),
                                  IconButton.filledTonal(
                                    onPressed: isGuest
                                        ? () {}
                                        : () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                    ),
                                                    itemCount: user.awards.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      final award = user.awards[index];

                                                      return IconButton.filledTonal(
                                                        onPressed: () => awardPost(ref, award, context),
                                                        icon: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Image.asset(Constants.awards[award]!),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                    icon: Icon(Icons.card_giftcard_outlined, color: Theme.of(context).colorScheme.onPrimaryContainer,),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
