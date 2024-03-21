import 'package:equatable/equatable.dart';

import 'page.dart';

abstract class BookState extends Equatable {
  final List<PageModel> pages;
  final String title;

  const BookState(this.pages, this.title);
  @override
  List<Object> get props => [pages, title];
}

class BookInitial extends BookState {
  const BookInitial(super.childName, super.title);
}
