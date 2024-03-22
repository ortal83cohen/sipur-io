import 'package:equatable/equatable.dart';
import 'package:sipur/top_level/books_cubit.dart';

abstract class BookState extends Equatable {
  final Book? book;

  const BookState(this.book);

  @override
  List<Object> get props => [book ?? ""];

  bool boolWithData() {
    return book?.id != null && book!.pages.isNotEmpty;
  }
}

class BookInitial extends BookState {
  const BookInitial(super.book);
}
