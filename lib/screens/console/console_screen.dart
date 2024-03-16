import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/card_wrapper.dart';
import 'package:sipur/route_manager.dart';
import 'package:sipur/screens/console/console_cubit.dart';

import '../../utils.dart';

class ConsoleScreen extends StatefulWidget {
  const ConsoleScreen({super.key});

  @override
  State<ConsoleScreen> createState() => _ConsoleState();
}

class _ConsoleState extends State<ConsoleScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ConsoleCubit(),
        child: BlocBuilder<ConsoleCubit, ConsoleState>(
            builder: (blockContext, state) {
          return Scaffold(
            appBar: isHorizontal(context)
                ? null
                : AppBar(
                    leadingWidth: 100,
                    toolbarHeight: 88,
                    title: Text("Console"),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
            extendBodyBehindAppBar: true,
            drawer: Drawer(
              backgroundColor: Colors.black,
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  // const DrawerHeader(
                  //   decoration: BoxDecoration(
                  //     color: Colors.blue,
                  //   ),
                  //   child: Text('Drawer Header'),
                  // ),
                  ListTile(
                    title: Text(
                      'subscription',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white),
                    ),
                    onTap: () async {
                      context.push(
                        RouteManager.console + "\\" + RouteManager.subscription,
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
                  ListTile(
                    title: const Text('Item 2'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                ],
              ),
            ),
            body: CardWrapper(
              drawer: isHorizontal(context)
                  ? Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'console',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(
                          height: 555,
                        ),
                        ListTile(
                          title: Text(
                            'subscription',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: Colors.white),
                          ),
                          onTap: () async {
                            context.push(
                              RouteManager.console +
                                  "\\" +
                                  RouteManager.subscription,
                            );
                          },
                        ),
                      ],
                    )
                  : null,
              Stack(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                children: [
                  Positioned(
                    top: 77,
                    left: 16,
                    child: Container(
                        height: 330,
                        width: 333,
                        child: ListView(
                          shrinkWrap: true,
                          children: ((state.books.map((key, value) {
                            return MapEntry(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () => context.push(
                                        RouteManager.console +
                                            "\\" +
                                            RouteManager.book,
                                        extra: key),
                                    child: Text('edit book $value'),
                                  ),
                                ),
                                '');
                          })) as Map<Widget, String>)
                              .keys
                              .toList(),
                        )),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () => context.push(
                          RouteManager.console + "\\" + RouteManager.book),
                      child: const Text('create new book'),
                    ),
                  ),
                ],
              ),
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          );
        }));
  }

// Future<void> initPaymentSheet() async {
//   try {
//     // 1. create payment intent on the server
//     final data = await _createTestPaymentSheet();
//
//     // 2. initialize the payment sheet
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         // Set to true for custom flow
//         customFlow: false,
//         // Main params
//         merchantDisplayName: 'Flutter Stripe Store Demo',
//         paymentIntentClientSecret: data['paymentIntent'],
//         // Customer keys
//         customerEphemeralKeySecret: data['ephemeralKey'],
//         customerId: data['customer'],
//         // Extra options
//         applePay: const PaymentSheetApplePay(
//           merchantCountryCode: 'US',
//         ),
//         googlePay: const PaymentSheetGooglePay(
//           merchantCountryCode: 'US',
//           testEnv: true,
//         ),
//         style: ThemeMode.dark,
//       ),
//     );
//     setState(() {
//       _ready = true;
//     });
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $e')),
//     );
//     rethrow;
//   }
// }
}
