import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/top_level/remote_config_cubit.dart';
import 'package:sipur/top_level/route_manager.dart';
import 'package:sipur/top_level/user_cubit.dart';

import 'firebase_options.dart';
import 'top_level/books_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter routerConfig = RouteManager().config();
  late RemoteConfigCubit remoteConfigCubit;
  late UserCubit userCubit;
  late BooksCubit booksCubit;

  @override
  void initState() {
    remoteConfigCubit = RemoteConfigCubit();
    userCubit = UserCubit(remoteConfigCubit);
    booksCubit = BooksCubit();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => userCubit),
        BlocProvider(create: (_) => booksCubit),
        BlocProvider(create: (_) => remoteConfigCubit),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        title: 'Sipur',
        theme: ThemeData(
          sliderTheme: SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
