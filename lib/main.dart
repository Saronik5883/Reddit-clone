import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
import 'package:reddit_tutorial/firebase_options.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/router.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "dev project",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Color brandColor = Color(0xFF44166f5);

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  Future<void> getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? dark){
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        final brightness = MediaQuery.of(context).platformBrightness;

        if(lightDynamic != null && dark != null){
          lightColorScheme = lightDynamic.harmonized()..copyWith();
          lightColorScheme = lightColorScheme.copyWith(secondary: brandColor);
          darkColorScheme = dark.harmonized()..copyWith();
          darkColorScheme = dark.copyWith(secondary: brandColor);
        } else {
          lightColorScheme = ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.light);
          darkColorScheme = ColorScheme.fromSeed(seedColor: brandColor, brightness: Brightness.dark);
        }

        final colorScheme = brightness == Brightness.dark ? darkColorScheme : lightColorScheme;

        return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit Clone',
            //theme: ref.watch(themeNotifierProvider),
            theme: ThemeData(
              fontFamily: 'Roboto',
              colorScheme: colorScheme,
              useMaterial3: true,
            ),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                 // if (userModel != null) {
                    return loggedInRoute;
                  //}
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
      },
    );
  }
}
