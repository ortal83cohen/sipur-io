import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/screens/pricing_screen.dart';
import 'package:sipur/top_level/route_manager.dart';
import 'package:sipur/top_level/user_cubit.dart';
import 'package:sipur/widgets/card_wrapper.dart';
import 'package:uuid/v4.dart';

import 'create_cubit.dart';
import 'create_state.dart';

class CreateScreen extends StatefulWidget {
  final String? bookId;

  const CreateScreen(this.bookId, {super.key});

  @override
  State<CreateScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<CreateScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => CreateCubit(widget.bookId ?? const UuidV4().generate(),
            context.watch<UserCubit>()),
        child: BlocBuilder<CreateCubit, CreateState>(
            builder: (blockContext, state) {
          if (state is CreateNoFounds) {
            return const PricingScreen(true);
          }
          return Scaffold(
              body: CardWrapper(ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Create a new story",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text("Every good story starts with a good idea",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium)
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              TextField(
                controller: TextEditingController()..text = state.childName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter child name',
                ),
                onChanged: (string) {
                  blockContext.read<CreateCubit>().setChildName(string);
                },
              ),
              TextField(
                controller: TextEditingController()..text = state.story,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Story',
                ),
                onChanged: (string) {
                  blockContext.read<CreateCubit>().setStory(string);
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    blockContext
                        .read<CreateCubit>()
                        .setStory(((CreateState.stories..shuffle())).first);
                  },
                  child: const Text("I'm feeling lucky")),
              const SizedBox(
                height: 16,
              ),
              DropdownButton<String>(
                value: state.readerAge,
                isDense: true,
                onChanged: (String? newValue) {
                  blockContext.read<CreateCubit>().setReaderAge(newValue);
                },
                items: CreateState.readerAgeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 55,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await blockContext.read<CreateCubit>().createBook();

                      if (!context.mounted) {
                        return;
                      }
                      Router.neglect(
                          context,
                          () => context.go(RouteManager.book,
                              extra: (state.bookId, true)));
                    } catch (e) {
                      if (e is InsufficientFundException) {
                        await _dialogBuilder(context);
                      }
                    }
                  },
                  child: const Text("Execute"))
            ],
          ))
              // This trailing comma makes auto-formatting nicer for build methods.
              );
        }));
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Basic dialog title'),
        content: const Text(
          'A dialog is a type of modal window that\n'
          'appears in front of app content to\n'
          'provide critical information, or prompt\n'
          'for a decision to be made.',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Top up now'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text("Thanks, I'll do it later"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
