import 'package:flutter/material.dart';

import '../widgets/card_wrapper.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

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
        Center(child: Text('Pricing Page')),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
