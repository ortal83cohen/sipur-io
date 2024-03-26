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
            const SizedBox(
              height: 16,
            ),
            Text(
              'Pricing',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 44,
            ),
            if (widget.noFounds) ...[
              const Text(
                  "You don't have enough funds to create this book, please top up"),
            ],
            const Price(),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Price extends StatelessWidget {
  const Price({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 555,
        width: 650,
        color: Colors.cyan,
        child: Column(
          children: [
            Text('You can top up as much and many times as you like'),
            Text(
                '* One page costs 1 euro, and you can choose to create a 1-30 page book'),
            Text(
                '* Generating and downloading your book as PDF costs 3 euros, this way, you can print it yourself'),
            Text(
                '* Having a printed book delivered to you costs between 8-12 euros'),
            Text(' notes:'),
            Text('* Own the rights to your stories & images'),
            Text('* Phone mode: Display and read from your phone/tablet'),
            Text('* Customer support'),
            ListTile(
              textColor: Colors.black,
              style: ListTileStyle.drawer,
              title: AutoSizeText(
                maxLines: 1,
                'Top up',
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
            )
          ],
        ));
  }
}
