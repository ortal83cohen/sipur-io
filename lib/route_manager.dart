import 'dart:math';

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
import 'screens/subscription/subscription.dart';

CustomTransitionPage _buildPageWithFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child1,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child1,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child2) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          // this boolean tells us if we're on the first or second half of the animation
          // final isAnimationFirstHalf = animation.value.abs() < 0.5;
          // decide which page we need to show
          // final child = isAnimationFirstHalf ? child2 : child1;
          // map values between [0, 1] to values between [0, pi]
          final rotationValue = animation.value * pi;
          // calculate the correct rotation angle depening on which page we need to show
          final rotationAngle = pi - rotationValue; // rotationValue;
          // calculate tilt
          var tilt = (animation.value - 0.5).abs() - 0.5;

          // make this a small value (positive or negative as needed)
          tilt *= -0.0004;
          return Transform(
            transform: Matrix4.rotationY(rotationAngle)
              // apply tilt value
              ..setEntry(3, 0, tilt),
            child: child2,
            alignment: Alignment.centerRight,
          );
        },
      );

      // FadeTransition(
      //   opacity: CurvedAnimation(
      //     parent: animation,
      //     curve: Interval(
      //       0.0,
      //       0.3,
      //       curve: Curves.linear,
      //     ),
      //   ),
      //   child: child,
      // );
    },
  );
}

class RouteManager {
  static String home = "/";
  static String console = "/console";
  static String book = "book";
  static String subscription = "subscription";
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
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithFadeTransition(
                context: context,
                state: state,
                child1: CardWrapper(SignInScreen(
                  providers: providers,
                  actions: [
                    AuthStateChangeAction<SignedIn>((context, state) {
                      context.go(RouteManager.console);
                    }),
                  ],
                )));
          },
        ),
        GoRoute(
          path: profile,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithFadeTransition(
                context: context,
                state: state,
                child1: ProfileScreen(
                  providers: providers,
                  actions: [
                    SignedOutAction((context) {
                      context.go(RouteManager.login);
                    }),
                  ],
                ));
          },
        ),
        GoRoute(
          path: home,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return _buildPageWithFadeTransition(
                context: context, state: state, child1: const HomeScreen());
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
            pageBuilder: (BuildContext context, GoRouterState state) {
              return _buildPageWithFadeTransition(
                  context: context,
                  state: state,
                  child1: const ConsoleScreen());
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
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return _buildPageWithFadeTransition(
                      context: context,
                      state: state,
                      child1: BookScreen((state.extra) as String?));
                },
              ),
              GoRoute(
                path: subscription,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return _buildPageWithFadeTransition(
                      context: context, state: state, child1: Subscription());
                },
              ),
            ]),
      ],
      errorBuilder: (context, state) => const ErrorScreen());
}
