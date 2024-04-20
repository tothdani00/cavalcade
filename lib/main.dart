import 'package:cavalcade/core/common/error_text.dart';
import 'package:cavalcade/core/common/loader.dart';
import 'package:cavalcade/features/auth/controller/auth_controller.dart';
import 'package:cavalcade/models/user_model.dart';
import 'package:cavalcade/router.dart';
import 'package:cavalcade/theme/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.watch(authStateChangeProvider).when(
      data: (data) {
        if (data != null) {
          getData(ref, data);
        }
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  });
}

@override
Widget build(BuildContext context) {
  return FutureBuilder<UserModel?>(
    future: ref.watch(authStateChangeProvider).when(
      data: (data) {
        if (data != null) {
          return ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
        }
        return Future.value(null);
      },
      loading: () => Future.value(null),
      error: (_, __) => Future.value(null),
    ),
    builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Loader();
      } else if (snapshot.hasError) {
        return ErrorText(error: snapshot.error.toString());
      } else {
        userModel = snapshot.data;
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Cavalcade',
          theme: ref.watch(themeNotifierProvider),
          routerDelegate: RoutemasterDelegate(
            routesBuilder: (context) {
              if(userModel != null){
                return loggedInRoute;
              }
              return loggedOutRoute;
            },
          ), 
          routeInformationParser: const RoutemasterParser(),
          );
        }
      },
    );
  }
}