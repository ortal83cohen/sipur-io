import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sipur/top_level/user_cubit.dart';

import 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  final String? bookId;
  final UserCubit userCubit;

  CreateCubit(this.bookId, this.userCubit)
      : super(CreateInitial(
            bookId ?? "no book", "", CreateState.readerAgeOptions[0], "")) {
    if (!userCubit.checkBalance()) {
      emit((state as CreateInitial).copyWithNoFounds());
    }
    if (bookId == null) {
      return;
    }
  }

  Future<void> createBook() async {
    if (userCubit.checkBalance()) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('books')
          .doc(bookId)
          .set(state.toMap(), SetOptions(merge: true));
    } else {
      emit((state).copyWithNoFounds());
    }
  }

  void setChildName(String string) {
    emit((state).copyWithInitial(childName: string));
  }

  void setReaderAge(string) {
    emit((state).copyWithInitial(readerAge: string));
  }

  void setStory(String string) {
    emit((state).copyWithInitial(story: string));
  }
}
