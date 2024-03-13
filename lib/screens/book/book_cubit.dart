import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sipur/screens/book/book_state.dart';

class BookCubit extends Cubit<BookState> {
  final String bookId;
  Stream<DocumentSnapshot>? _userStream;
  StreamSubscription? _streamSubscription;

  BookCubit(this.bookId) : super(const BookInitial("")) {
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
            .doc(bookId)
            .snapshots(includeMetadataChanges: false);

        _streamSubscription = _userStream?.listen((documentSnapshot) {
          Map? document = (jsonDecode(jsonEncode(documentSnapshot.data())));
          if (document != null) {
            emit(BookInitial(document["childName"]!));
          }
        });
        _streamSubscription?.onError((e, s) {
          print(e);
        });
      }
    });
  }

  void setChildName(String string) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books_params')
        .doc(bookId)
        .set({"childName": string}, SetOptions(merge: true));
  }
}
