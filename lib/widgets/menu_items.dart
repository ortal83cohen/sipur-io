import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../route_manager.dart';

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
        SizedBox(
          height: 200,
        ),
        ListTile(
          style: ListTileStyle.drawer,
          title: AutoSizeText(
            maxLines: 1,
            'Subscription',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white),
          ),
          onTap: () async {
            context.push(
              "${RouteManager.console}\\${RouteManager.subscription}",
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
        // ListTile(
        //   title:        ,
        //   onTap: () {
        //
        //   },
        // ),
        // Stripe.buildPaymentRequestButton(
        //   onPressed: () {
        //     print('onPressed');
        //   },
        //   paymentRequestCreateOptions:
        //       PlatformPayWebPaymentRequestCreateOptions(
        //     country: 'DE',
        //     currency: 'EUR',
        //     total:
        //         PlatformPayWebPaymentItem(amount: 233, label: '23'),
        //   ),
        // ),

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
