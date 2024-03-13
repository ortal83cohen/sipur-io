import 'package:equatable/equatable.dart';

abstract class BookState extends Equatable {
  final String childName;
  const BookState(this.childName);
}

class BookInitial extends BookState {
  const BookInitial(super.childName);

  @override
  List<Object> get props => [childName];
}
