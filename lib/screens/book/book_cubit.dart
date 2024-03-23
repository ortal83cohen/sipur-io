import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sipur/screens/book/book_state.dart';
import 'package:sipur/top_level/books_cubit.dart';

class BookCubit extends Cubit<BookState> {
  final String bookId;
  final BooksCubit booksCubit;

  BookCubit(this.bookId, this.booksCubit) : super(const BookInitial(null)) {
    emit(BookInitial(booksToBook(bookId, booksCubit.state.books)));
    booksCubit.stream.listen((event) {
      emit(BookInitial(booksToBook(bookId, event.books)));
    });

    // Stream<DocumentSnapshot>? _userStream;
    // StreamSubscription? _streamSubscription;

    // FirebaseAuth.instance.authStateChanges().listen((user) async {
    //   _streamSubscription?.cancel();
    //   _userStream = null;
    //   if (user == null) {
    //     FirebaseFirestore.instance
    //         .clearPersistence()
    //         .onError((error, stackTrace) => null);
    //     // if (!_controller.isClosed) {
    //     //   _controller.sink.add(null);
    //     // }
    //   } else {
    //     _userStream = FirebaseFirestore.instance
    //         .collection('users')
    //         .doc(user.uid)
    //         .collection('books')
    //         .doc(bookId)
    //         .snapshots(includeMetadataChanges: false);
    //
    //     _streamSubscription = _userStream?.listen((documentSnapshot) {
    //       Map? document = (jsonDecode(jsonEncode(documentSnapshot.data())));
    //       if (document != null) {
    //         List<PageModel> list = [];
    //         for (var element in (document["book"]["pages"] as List)) {
    //           list.add(PageModel.fromMap(element));
    //         }
    //         emit(BookInitial(list, document["book"]["title"]));
    //       }
    //     });
    //     _streamSubscription?.onError((e, s) {
    //       print(e);
    //     });
    //   }
    // });
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
    } catch (e) {
      Logger().e(e);
    }
  }

  void setChildName(String string) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .doc(bookId)
        .set({"childName": string}, SetOptions(merge: true));
  }

  void setReaderAge(string) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .doc(bookId)
        .set({"readerAge": string}, SetOptions(merge: true));
  }

  void setStory(String string) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .doc(bookId)
        .set({"story": string}, SetOptions(merge: true));
  }

  Book? booksToBook(String bookId, List<Book> books) {
    if (books.isEmpty) {
      return null;
    }
    try {
      return booksCubit.state.books
          .firstWhere((element) => element.id == bookId);
    } catch (e) {
      return null;
    }
  }
}
