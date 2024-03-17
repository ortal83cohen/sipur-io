import 'package:equatable/equatable.dart';

abstract class BookState extends Equatable {
  final String childName;
  final String readerAge;
  static final List<String> readerAgeOptions = [
    "1-2",
    "2-3",
    "3-4",
    "4-5",
    "5+"
  ];

  BookState(this.childName, this.readerAge);
}

class BookInitial extends BookState {
  BookInitial(super.childName, super.readerAge);

  @override
  List<Object> get props => [childName, readerAge];
}
