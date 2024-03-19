import 'package:equatable/equatable.dart';

import 'page.dart';

abstract class BookState extends Equatable {
  final List<PageModel> pages;

  const BookState(this.pages);
}

class BookInitial extends BookState {
  const BookInitial(super.childName);

  @override
  List<Object> get props => [pages];
}
