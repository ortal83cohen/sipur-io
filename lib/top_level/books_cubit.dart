import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(BooksState.non()) {
    Stream<QuerySnapshot>? userStream;
    StreamSubscription? streamSubscription;

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      streamSubscription?.cancel();
      userStream = null;
      if (user == null) {
        FirebaseFirestore.instance
            .clearPersistence()
            .onError((error, stackTrace) => null);
        emit(BooksState.non());
      } else {
        userStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('books')
            .where('book', isNull: false)
            .snapshots(includeMetadataChanges: false);

        streamSubscription = userStream!.listen((documentSnapshot) {
          List<Book> books = [];
          for (var element in documentSnapshot.docs) {
            books.add(Book.fromMap(jsonDecode(jsonEncode(element.data()))));
          }
          emit(BooksState.fromBooks(books));
        });
        streamSubscription?.onError((e, s) {});
      }
    });
  }
}
