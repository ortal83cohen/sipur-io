import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sipur/top_level/books_cubit.dart';

part 'console_state.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  final BooksCubit booksCubit;
  ConsoleCubit(this.booksCubit) : super(const ConsoleInitial({})) {
    emitBooks(booksCubit.state);
    booksCubit.stream.listen((event) {
      emitBooks(event);
    });
  }

  void emitBooks(BooksState event) {
    Map<String, String> books = {};
    for (var book in event.books) {
      books[book.id] = book.getTitle();
    }
    emit(ConsoleInitial(books));
  }
}
