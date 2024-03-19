import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sipur/route_manager.dart';
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
        create: (_) => CreateCubit(widget.bookId ?? const UuidV4().generate()),
        child: BlocBuilder<CreateCubit, CreateState>(
            builder: (blockContext, state) {
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
                    await blockContext.read<CreateCubit>().getBook();
                    if (!context.mounted) {
                      return;
                    }
                    Router.neglect(
                        context,
                        () =>
                            context.go(RouteManager.book, extra: state.bookId));
                    // GoRouter.of(context)
                    //     .go(RouteManager.book, extra: state.bookId);
                  },
                  child: const Text("Execute"))
            ],
          ))
              // This trailing comma makes auto-formatting nicer for build methods.
              );
        }));
  }
}
