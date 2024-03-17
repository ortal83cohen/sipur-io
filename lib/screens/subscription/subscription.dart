import 'dart:async';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

typedef _CheckoutSessionSnapshot = DocumentSnapshot<Map<String, dynamic>>;

class Subscription extends StatefulWidget {
  const Subscription({
    super.key,
  });

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final StreamController<_CheckoutSessionSnapshot> _controller =
      StreamController<_CheckoutSessionSnapshot>();

  @override
  void initState() {
    super.initState();
    Future.value().then((value) async {
      final price = await FirebaseFirestore.instance
          .collection('products')
          .doc('prod_Pki7n5KbAG1hVX')
          .collection('prices')
          .where('active', isEqualTo: true)
          .limit(1)
          .get();
      String url = Uri.base.origin; // window.location.origin
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("checkout_sessions")
          .add({
        "client": "web",
        "mode": "payment", //""subscription",
        "price": price.docs[0].id,
        "success_url": "$url/#/sub_success",
        "cancel_url": "$url/#/sub_cancel"
      });

      Stream<_CheckoutSessionSnapshot> sessionStream = FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("checkout_sessions")
          .doc(docRef.id)
          .snapshots();
      sessionStream.listen((event) {
        _controller.add(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_CheckoutSessionSnapshot>(
      stream: _controller.stream,
      builder: (BuildContext context,
          AsyncSnapshot<_CheckoutSessionSnapshot> snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.hasData == false) {
          return const Text('Something went wrong');
        }
        final data = snapshot.requireData.data()!;
        if (data.containsKey('sessionId') && data.containsKey('url')) {
          html.window.location.href = data['url']
              as String; // open the new window with Stripe Checkout Page URL
          return const SizedBox();
        } else if (data.containsKey('error')) {
          return Text(
            data['error']['message'] as String? ?? 'Error processing payment.',
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
