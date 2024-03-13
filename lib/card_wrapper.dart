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
    return Container(
      color: Colors.black,
      //     width:
      //     MediaQuery.of(context).size.width * ((drawer == null) ? 0 : 0.1),
      // height: MediaQuery.of(context).size.height,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width *
                ((drawer == null) ? 0 : 0.1),
            height: MediaQuery.of(context).size.height,
            child: drawer,
          ),
          Container(
            width: MediaQuery.of(context).size.width *
                ((drawer == null) ? 1 : 0.9),
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
