import 'package:flutter/material.dart';

class CardWrapper extends StatelessWidget {
  final Widget child;
  final Widget? drawer;

  const CardWrapper(
    this.child, {
    super.key,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (drawer != null)
          Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height,
            child: drawer,
          ),
        Container(
          width:
              MediaQuery.of(context).size.width * (drawer != null ? 0.85 : 1),
          height: MediaQuery.of(context).size.height,
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 0),
          color: Colors.black,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16))),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
