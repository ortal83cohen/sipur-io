import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sipur/card_wrapper.dart';
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
              body: CardWrapper(ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Text("Create a new story"),
                    Text("Every good story starts with a good idea")
                  ],
                ),
              ),
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
              SizedBox(
                height: 55,
              ),
              ElevatedButton(
                  onPressed: () {
                    blockContext.read<BookCubit>().getBook();
                  },
                  child: Text("Execute"))
            ],
          ))
              // This trailing comma makes auto-formatting nicer for build methods.
              );
        }));
  }
}
