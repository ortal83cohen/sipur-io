import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sipur/screens/book/book_cubit.dart';
import 'package:sipur/screens/book/book_state.dart';
import 'package:uuid/v4.dart';

class BookScreen extends StatefulWidget {
  final String? bookId;
  const BookScreen(this.bookId, {super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => BookCubit(widget.bookId ?? const UuidV4().generate()),
        child:
            BlocBuilder<BookCubit, BookState>(builder: (blockContext, state) {
          return Scaffold(
              appBar: AppBar(
                // TRY THIS: Try changing the color here to a specific color (to
                // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
                // change color while the other colors stay the same.
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: const Text("book Screen"),
              ),
              body: ListView(
                children: [
                  TextField(
                    controller: TextEditingController()..text = state.childName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter child name',
                    ),
                    onSubmitted: (string) {
                      blockContext.read<BookCubit>().setChildName(string);
                    },
                    onChanged: (string) {},
                  ),
                ],
              )
              // This trailing comma makes auto-formatting nicer for build methods.
              );
        }));
  }
}
