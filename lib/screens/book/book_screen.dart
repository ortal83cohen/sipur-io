import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sipur/screens/book/book_cubit.dart';
import 'package:sipur/screens/book/book_state.dart';
import 'package:sipur/widgets/card_wrapper.dart';
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
                    Text(
                      "THE BOOK",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    ...state.pages
                        .map((e) => Column(
                              children: [
                                Text(e.text),
                                Image.network(e.picture)
                              ],
                            ))
                        .toList()
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const SizedBox(
                height: 55,
              ),
            ],
          ))
              // This trailing comma makes auto-formatting nicer for build methods.
              );
        }));
  }
}
