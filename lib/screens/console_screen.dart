import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class ConsoleScreen extends StatefulWidget {
  const ConsoleScreen({super.key});

  @override
  State<ConsoleScreen> createState() => _ConsoleState();
}

class _ConsoleState extends State<ConsoleScreen> {
  List book = [];
  List pictures = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (book.isEmpty) {
      Future.value().then((value) async {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'getBook',
          options: HttpsCallableOptions(
            timeout: const Duration(seconds: 5),
          ),
        );

        try {
          final result = await callable.call({'text': 'test'});
          setState(() {
            book.clear();
            Map b = (result.data['book'] as Map);
            int length = b.length;
            for (int i = 1; i <= length; i++) {
              Map page = b[i.toString()] as Map;
              book.add(page["text"]);
              pictures.add(page["picture"]);
            }
          });
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('ERROR: $e'),
              ),
            );
          }
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Console Screen"),
      ),
      body: Stack(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: [
          ListView(
            children: pictures.map((p) => Image.network(p)).toList(),
          ),
          ListView(
            children: book
                .map((s) => Text(
                      s,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ))
                .toList(),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
