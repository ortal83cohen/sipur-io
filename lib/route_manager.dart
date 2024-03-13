import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/screens/book/book_screen.dart';
import 'package:sipur/screens/console/console_screen.dart';
import 'package:sipur/screens/error_screen.dart';
import 'package:sipur/screens/home_screen.dart';

import 'card_wrapper.dart';

class RouteManager {
  static String home = "/";
  static String console = "/console";
  static String book = "book";
  static String login = "/login";
  static String profile = "/profile";
  final List<AuthProvider> providers = [
    EmailAuthProvider(),
    GoogleProvider(
        clientId:
            '209098881200-ai1lr7ms4sa3brit42r11fvk4ubi79cc.apps.googleusercontent.com')
  ];

  GoRouter config() => GoRouter(
      // navigatorKey: navigatorKey,
      initialLocation: home,
      observers: [],
      routes: <RouteBase>[
        GoRoute(
          path: login,
          builder: (BuildContext context, GoRouterState state) {
            return CardWrapper(SignInScreen(
              providers: providers,
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  context.go(RouteManager.console);
                }),
              ],
            ));
          },
        ),
        GoRoute(
          path: profile,
          builder: (BuildContext context, GoRouterState state) {
            return ProfileScreen(
              providers: providers,
              actions: [
                SignedOutAction((context) {
                  context.go(RouteManager.login);
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: home,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
            path: console,
            redirect: (BuildContext context, GoRouterState state) {
              if (FirebaseAuth.instance.currentUser == null) {
                return login;
              }
              return null;
            },
            builder: (BuildContext context, GoRouterState state) {
              return const ConsoleScreen();
            },
            routes: [
              GoRoute(
                path: book,
                // redirect: (BuildContext context, GoRouterState state) {
                //   if (FirebaseAuth.instance.currentUser == null) {
                //     return login;
                //   }
                //   return null;
                // },
                builder: (BuildContext context, GoRouterState state) {
                  return BookScreen((state.extra) as String?);
                },
              ),
            ]),
      ],
      errorBuilder: (context, state) => const ErrorScreen());
}
