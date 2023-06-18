import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
import '../../../core/common/loader.dart';
import '../../../current_uid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if(user==null) {
      return const Loader();
    }
    currentUserId = user.uid;
    return Scaffold(
      body: Constants.tabWidgets[_page],
      //drawer: const CommunityListDrawer(),
      //endDrawer: isGuest ? null : const ProfileDrawer(),
    );
  }
}

