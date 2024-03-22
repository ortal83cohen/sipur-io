import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipur/screens/book/book_cubit.dart';
import 'package:sipur/screens/book/book_state.dart';
import 'package:sipur/widgets/card_wrapper.dart';

import '../../top_level/books_cubit.dart';

class BookScreen extends StatefulWidget {
  final String bookId;
  final bool withAnimations;

  const BookScreen(this.bookId, {super.key, required this.withAnimations});

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
        create: (_) => BookCubit(widget.bookId, context.watch<BooksCubit>()),
        child:
            BlocBuilder<BookCubit, BookState>(builder: (blockContext, state) {
          if (state.book == null) {
            return Container();
          }
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
                      Text(
                        state.book!.getTitle(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (!state.boolWithData())
                        const CircularProgressIndicator(),
                      ...state.book!.pages.map((e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 800),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 32),
                                  child: e.text == "loading"
                                      ? AnimatedTextKit(
                                          key: const Key("1"),
                                          animatedTexts: [
                                            TypewriterAnimatedText(
                                              "|",
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                          ],
                                        )
                                      : (widget.withAnimations
                                          ? AnimatedTextKit(
                                              key: const Key("2"),
                                              isRepeatingAnimation: false,
                                              animatedTexts: [
                                                TypewriterAnimatedText(
                                                  e.text,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall,
                                                ),
                                              ],
                                            )
                                          : Text(
                                              e.text,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            )),
                                ),
                              ),
                              if (e.picture != null)
                                AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 1500),
                                  firstChild: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade50,
                                      highlightColor: Colors.grey.shade300,
                                      child: Container(
                                        width: 800.0,
                                        height: 600.0,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
                                          color: Colors.black,
                                        ),
                                      )),
                                  secondChild: Container(
                                    width: 800.0,
                                    height: 600.0,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            e.picture!,
                                          )),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                    ),
                                  ),
                                  crossFadeState: e.picture == "loading"
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                ),
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
