import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  final String bookId;
  Stream<DocumentSnapshot>? _userStream;
  StreamSubscription? _streamSubscription;

  CreateCubit(this.bookId)
      : super(CreateInitial(bookId, "", CreateState.readerAgeOptions[0], "")) {
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
            emit(CreateInitial(
                bookId,
                document["childName"] ?? "",
                (document.containsKey("readerAge") &&
                        document["readerAge"] != null)
                    ? document["readerAge"]
                    : CreateState.readerAgeOptions[0],
                document["story"] ?? ""));
          }
        });
        _streamSubscription?.onError((e, s) {
          print(e);
        });
      }
    });
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
      print(e);
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
}
