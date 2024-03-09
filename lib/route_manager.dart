import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, AuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/console_screen.dart';
import 'package:sipur/error_screen.dart';
import 'package:sipur/home_screen.dart';

class RouteManager {
  static String home = "/";
  static String console = "console";
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
            return SignInScreen(
              providers: providers,
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  context.go(RouteManager.profile);
                }),
              ],
            );
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
          routes: <RouteBase>[
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
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => const ErrorScreen());
}
