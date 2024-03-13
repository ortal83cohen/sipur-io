import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'console_state.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  ConsoleCubit() : super(ConsoleInitial({})) {
    Stream<QuerySnapshot>? _userStream;
    StreamSubscription? _streamSubscription;

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _streamSubscription?.cancel();
      _userStream = null;
      if (user == null) {
        FirebaseFirestore.instance
            .clearPersistence()
            .onError((error, stackTrace) => null);
        // if (!_controller.isClosed) {
        //   _controller.sink.add(null);
        // }
      } else {
        _userStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books_params')
            .snapshots(includeMetadataChanges: false);

        _streamSubscription = _userStream!.listen((documentSnapshot) {
          Map<String, String> books = {};
          for (var element in documentSnapshot.docs) {
            books[element.id] =
                (jsonDecode(jsonEncode(element.data()))['childName']);
          }
          emit(ConsoleInitial(books));
          // Map? document = (jsonDecode(jsonEncode(documentSnapshot.data())));
          // if (document != null) {
          //   emit(BookInitial(document["childName"]!));
          // }
        });
        _streamSubscription?.onError((e, s) {});
      }
    });
  }
}
