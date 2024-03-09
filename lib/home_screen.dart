import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/route_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Sipur.Ai"),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () =>
                    context.go(RouteManager.home + RouteManager.console),
                child: const Text('Open Console'),
              ),
            )
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
