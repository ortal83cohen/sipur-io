import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipur/screens/book/book_cubit.dart';
import 'package:sipur/screens/book/book_state.dart';
import 'package:sipur/widgets/card_wrapper.dart';

class BookScreen extends StatefulWidget {
  final String bookId;

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
        create: (_) => BookCubit(widget.bookId),
        child:
            BlocBuilder<BookCubit, BookState>(builder: (blockContext, state) {
          return Scaffold(
              body: CardWrapper(ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "THE BOOK",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      if (state.pages.isEmpty)
                        const CircularProgressIndicator(),
                      ...state.pages.map((e) => Column(
                            children: [
                              Text(e.text),
                              if (e.picture != null)
                                e.picture == "loading"
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey.shade50,
                                        highlightColor: Colors.grey.shade300,
                                        child: Container(
                                          width: 400.0,
                                          height: 300.0,
                                          color: Colors.black,
                                        ))
                                    : Image.network(e.picture!)
                            ],
                          ))
                    ],
                  ),
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
