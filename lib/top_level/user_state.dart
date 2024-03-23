part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {
  final int? balance;
  final String? email;
  final String? stripeId;
  final String? stripeLink;
  final String? uid;

  @override
  List<Object?> get props =>
      [balance ?? "", email, stripeId ?? "", stripeLink ?? "", uid];

  const UserState(
      this.balance, this.email, this.stripeId, this.stripeLink, this.uid);

  String getBalance() {
    var format = NumberFormat.currency(locale: "en_DE", symbol: "€");
    return "balance: ${format.format((balance ?? 0) / 100)}";
  }

  factory UserState.non() {
    return const NoUser();
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserInitial(
      map.containsKey('balance') ? map['balance'] as int : 0,
      map['email'] as String,
      map.containsKey('stripeId') ? map['stripeId'] as String : '',
      map.containsKey('stripeLink') ? map['stripeLink'] as String : '',
      map['uid'] as String,
    );
  }
}

class UserInitial extends UserState {
  const UserInitial(
      super.balance, super.email, super.stripeId, super.stripeLink, super.uid);
}

class NoUser extends UserState {
  const NoUser() : super(null, null, null, null, null);
}
