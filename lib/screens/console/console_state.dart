part of 'console_cubit.dart';

@immutable
abstract class ConsoleState {
  final Map<String, String> books;

  const ConsoleState(this.books);
}

class ConsoleInitial extends ConsoleState {
  const ConsoleInitial(super.books);
}
