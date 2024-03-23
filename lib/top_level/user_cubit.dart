import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState.non()) {
    Stream<DocumentSnapshot>? userStream;
    StreamSubscription? streamSubscription;

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      streamSubscription?.cancel();
      userStream = null;
      if (user == null) {
        FirebaseFirestore.instance
            .clearPersistence()
            .onError((error, stackTrace) => null);
        emit(UserState.non());
      } else {
        userStream = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(includeMetadataChanges: false);

        streamSubscription = userStream!.listen((documentSnapshot) {
          emit(UserState.fromMap(
              jsonDecode(jsonEncode(documentSnapshot.data()))));
        });
        streamSubscription?.onError((e, s) {});
      }
    });
  }

  bool checkBalance() {
    int bookPrice = 2000;
    return (state.balance != null && state.balance! >= bookPrice);
  }
}

class InsufficientFundException implements Exception {
  InsufficientFundException();

  @override
  String toString() => 'Insufficient Fund Exception';
}
