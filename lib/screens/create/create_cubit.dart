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
      : super(CreateInitial(bookId ?? "no book", 2, "",
            CreateState.readerAgeOptions[0], "", true)) {
    emit((state as CreateInitial).copy(enoughFunds: userCubit.checkBalance(2)));
  }

  Future<void> createBook() async {
    if (userCubit.checkBalance(state.pages)) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('books')
          .doc(bookId)
          .set(state.toMap(), SetOptions(merge: true));
    } else {
      emit((state).copy(enoughFunds: false));
    }
  }

  void setChildName(String string) {
    emit((state).copy(childName: string));
  }

  void setReaderAge(string) {
    emit((state).copy(readerAge: string));
  }

  void setStory(String string) {
    emit((state).copy(story: string));
  }

  void setPages(int int) {
    emit((state).copy(pages: int, enoughFunds: userCubit.checkBalance(int)));
  }
}
