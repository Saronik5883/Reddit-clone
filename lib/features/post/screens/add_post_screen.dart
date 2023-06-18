import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = kIsWeb ? 360 : 120;
    double iconSize = kIsWeb ? 120 : 60;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Routemaster.of(context).pop();
              },
            ),
            title: const Text('Create a Post'),
            centerTitle: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => navigateToType(context, 'image'),
                  child: SizedBox(
                    height: cardHeightWidth-30,
                    width: cardHeightWidth+270,
                    child: Card(
                      child: ListTile(
                        leading:IconButton.filledTonal(
                            onPressed: (){}, icon: Icon(Icons.photo)
                        ) ,
                        title: Text(
                            'Image', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimaryContainer)
                        ),
                        subtitle: Text('Post an image'),
                      )
                    ),
                  ),

                ),
                InkWell(
                  onTap: () => navigateToType(context, 'text'),
                  child: SizedBox(
                    height: cardHeightWidth-30,
                    width: cardHeightWidth+270,
                    child: Card(
                        child: ListTile(
                          leading:IconButton.filledTonal(
                              onPressed: (){}, icon: const Icon(Icons.text_fields)
                          ) ,
                          title: Text(
                              'Text', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimaryContainer)
                          ),
                          subtitle: const Text('Create a text post'),
                        )
                    ),
                  ),

                ),
                InkWell(
                  onTap: () => navigateToType(context, 'link'),
                  child: SizedBox(
                    height: cardHeightWidth-30,
                    width: cardHeightWidth+270,
                    child: Card(
                        child: ListTile(
                          leading:IconButton.filledTonal(
                              onPressed: (){}, icon: Icon(Icons.link)
                          ) ,
                          title: Text(
                              'Link', style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onPrimaryContainer)
                          ),
                          subtitle: Text('Create a link post'),
                        )
                    ),
                  ),

                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
