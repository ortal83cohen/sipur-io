import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sipur/top_level/user_cubit.dart';

import '../../top_level/remote_config_cubit.dart';
import 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  final String? _bookId;
  final UserCubit _userCubit;
  late final int _pagePrice;
  final RemoteConfigCubit _remoteConfigCubit;

  CreateCubit(this._bookId, this._userCubit, this._remoteConfigCubit)
      : super(CreateInitial(_bookId ?? "no book", 2, 0, "",
            CreateState.readerAgeOptions[0], "", true)) {
    _pagePrice = _remoteConfigCubit
        .state.remoteConfig[RemoteConfigItems.pagePrice.name]!
        .asInt();
    emit((state as CreateInitial)
        .copy(enoughFunds: checkBalance(2), finalPrice: finalPrice(2)));
  }

  Future<void> createBook() async {
    if (checkBalance(state.pages)) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('books')
          .doc(_bookId)
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

  void setPages(int numberOfPages) {
    emit((state).copy(
        pages: numberOfPages,
        enoughFunds: checkBalance(numberOfPages),
        finalPrice: finalPrice(numberOfPages)));
  }

  bool checkBalance(int numberOfPages) {
    return (_userCubit.state.balance != null &&
        _userCubit.state.balance! >= finalPrice(numberOfPages));
  }

  int finalPrice(int numberOfPages) {
    return _pagePrice * numberOfPages;
  }
}
