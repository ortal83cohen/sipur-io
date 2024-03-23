// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:sipur/top_level/user_cubit.dart';

import '../top_level/route_manager.dart';

class MenuItems extends StatelessWidget {
  const MenuItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const DrawerHeader(
        //   decoration: BoxDecoration(
        //     color: Colors.blue,
        //   ),
        //   child: Text('Drawer Header'),
        // ),
        const SizedBox(
          height: 200,
        ),
        ListTile(
          style: ListTileStyle.drawer,
          title: AutoSizeText(
            maxLines: 1,
            'payment',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          subtitle: AutoSizeText(
            maxLines: 1,
            context.watch<UserCubit>().state.getBalance(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          onTap: () async {
            context.push(
              "${RouteManager.console}\\${RouteManager.payment}",
            );
          },
        ),
        ListTile(
          style: ListTileStyle.drawer,
          title: AutoSizeText(
            maxLines: 1,
            'Pricing',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          onTap: () async {
            context.push(
              RouteManager.pricing,
            );
          },
        ),
        ListTile(
          style: ListTileStyle.drawer,
          title: AutoSizeText(
            maxLines: 1,
            'portal',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          onTap: () async {
            HttpsCallable callable = FirebaseFunctions.instanceFor(
                    app: Firebase.app(), region: 'europe-west1')
                .httpsCallable(
              'ext-firestore-stripe-payments-createPortalLink',
              // 'https://europe-west1-sipur-ai.cloudfunctions.net/ext-firestore-stripe-payments-createPortalLink',
              options: HttpsCallableOptions(
                timeout: const Duration(seconds: 10),
              ),
            );
            try {
              final data = await callable.call({
                'returnUrl': html.window.location.origin,
                'locale': "auto",
                // Optional, defaults to "auto"
                // 'configuration':
                //     "bpc_1JSEAKHYgolSBA358VNoc2Hs", // Optional ID of a portal configuration: https://stripe.com/docs/api/customer_portal/configuration
              });
              html.window.location.href = data.data['url'] as String;
            } catch (e) {
              Logger().e(e);
            }
          },
        ),

        const Spacer(),
        ListTile(
          style: ListTileStyle.drawer,
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? ""),
          ),
          title: AutoSizeText(
            maxLines: 1,
            FirebaseAuth.instance.currentUser?.displayName ?? "",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          subtitle: AutoSizeText(
            maxLines: 1,
            FirebaseAuth.instance.currentUser?.email ?? "",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          onTap: () async {
            context.push(
              RouteManager.profile,
            );
          },
        ),
      ],
    );
  }
}
