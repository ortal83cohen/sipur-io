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
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (drawer != null)
                Drawer(
                  width: 230,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          // topLeft: Radius.circular(16),
                          // bottomLeft: Radius.circular(16
                          )),
                  backgroundColor: Colors.black,
                  child: drawer,
                ),
              Expanded(
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  // padding: const EdgeInsets.only(
                  //     top: 16, bottom: 16, left: 16, right: 0),
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 8, bottom: 8, left: drawer != null ? 0 : 8),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16))),
                      color: Colors.white,
                      child: Center(
                        child: SizedBox(
                          width: width > 500 ? width * 0.6 : width * 0.90,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // return Row(
    //   children: [
    //     if (drawer != null)
    //       Drawer(
    //         backgroundColor: Colors.black,
    //         child: drawer,
    //       ),
    //     Container(
    //       width:
    //           MediaQuery.of(context).size.width * (drawer != null ? 0.85 : 1),
    //       height: MediaQuery.of(context).size.height,
    //       padding:
    //           const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 0),
    //       color: Colors.black,
    //       child: Card(
    //         shape: const RoundedRectangleBorder(
    //             borderRadius: BorderRadius.only(
    //                 topLeft: Radius.circular(16),
    //                 bottomLeft: Radius.circular(16))),
    //         color: Colors.white,
    //         child: Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: child,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
