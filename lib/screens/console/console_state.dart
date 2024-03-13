part of 'console_cubit.dart';

@immutable
abstract class ConsoleState {
  final Map<String, String> books;

  ConsoleState(this.books);
}

class ConsoleInitial extends ConsoleState {
  ConsoleInitial(super.books);
}
