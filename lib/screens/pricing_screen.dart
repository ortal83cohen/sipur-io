import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../top_level/route_manager.dart';
import '../top_level/user_cubit.dart';
import '../widgets/card_wrapper.dart';

class PricingScreen extends StatefulWidget {
  final bool noFounds;

  const PricingScreen(this.noFounds, {super.key});

  @override
  State<PricingScreen> createState() => _PricingState();
}

class _PricingState extends State<PricingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      // AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const Text("Sipur.Ai"),
      // ),
      body: CardWrapper(
        Column(
          children: [
            SizedBox(
              height: 44,
            ),
            if (widget.noFounds) ...[
              Text(
                  "You don't have enough funds to create this book, please top up"),
              ListTile(
                textColor: Colors.black,
                style: ListTileStyle.drawer,
                title: AutoSizeText(
                  maxLines: 1,
                  'payment',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.black),
                ),
                subtitle: AutoSizeText(
                  maxLines: 1,
                  context.watch<UserCubit>().state.getBalance(),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black),
                ),
                onTap: () async {
                  context.push(
                    "${RouteManager.console}\\${RouteManager.payment}",
                  );
                },
              ),
            ],
            Spacer(),
            Text('Pricing Page'),
            Spacer(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
