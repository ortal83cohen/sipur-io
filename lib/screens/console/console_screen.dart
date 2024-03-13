import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/card_wrapper.dart';
import 'package:sipur/route_manager.dart';
import 'package:sipur/screens/console/console_cubit.dart';

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
            // appBar: AppBar(
            //   // TRY THIS: Try changing the color here to a specific color (to
            //   // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            //   // change color while the other colors stay the same.
            //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            //   // Here we take the value from the MyHomePage object that was created by
            //   // the App.build method, and use it to set our appbar title.
            //   title: const Text("Console Screen"),
            // ),
            body: CardWrapper(
              drawer: Column(
                children: [
                  Text(
                    'console',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
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
                    top: 16,
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
}
