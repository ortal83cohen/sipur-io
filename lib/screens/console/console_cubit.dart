import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'console_state.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  ConsoleCubit() : super(const ConsoleInitial({})) {
    Stream<QuerySnapshot>? userStream;
    StreamSubscription? streamSubscription;

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      streamSubscription?.cancel();
      userStream = null;
      if (user == null) {
        FirebaseFirestore.instance
            .clearPersistence()
            .onError((error, stackTrace) => null);
        // if (!_controller.isClosed) {
        //   _controller.sink.add(null);
        // }
      } else {
        userStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .where('book', isNull: false)
            .snapshots(includeMetadataChanges: false);

        streamSubscription = userStream!.listen((documentSnapshot) {
          Map<String, String> books = {};
          for (var element in documentSnapshot.docs) {
            Map book = jsonDecode(jsonEncode(element.data()));
            String title = book.containsKey('childName')
                ? book['childName']
                : (book.containsKey('story') ? book['story'] : "");
            books[element.id] = title;
          }
          emit(ConsoleInitial(books));
          // Map? document = (jsonDecode(jsonEncode(documentSnapshot.data())));
          // if (document != null) {
          //   emit(BookInitial(document["childName"]!));
          // }
        });
        streamSubscription?.onError((e, s) {});
      }
    });
  }
}
