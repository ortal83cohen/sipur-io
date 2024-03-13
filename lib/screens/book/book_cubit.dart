import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
            .collection('books')
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

  Future<void> getBook() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getBook',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );

    try {
      final result = await callable.call({'bookId': bookId});

      List book = [];
      List pictures = [];
      Map b = (result.data['book'] as Map);
      int length = b.length;
      for (int i = 1; i <= length; i++) {
        Map page = b[i.toString()] as Map;
        book.add(page["text"]);
        pictures.add(page["picture"]);
      }
    } catch (e) {}
  }
}
