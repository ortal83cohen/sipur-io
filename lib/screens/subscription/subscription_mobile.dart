import 'package:flutter/cupertino.dart';

import 'abstract_subscription.dart';

Subscription getInstance() => const SubscriptionMobile();

class SubscriptionMobile extends StatefulWidget implements Subscription {
  const SubscriptionMobile({
    super.key,
  });

  @override
  State<SubscriptionMobile> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<SubscriptionMobile> {
  @override
  Widget build(BuildContext context) {
    return const Text('not implemented');
  }
}
