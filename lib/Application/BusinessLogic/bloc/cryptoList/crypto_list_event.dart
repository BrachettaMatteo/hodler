part of 'crypto_list_bloc.dart';

@immutable
abstract class CryptoListEvent {}

class CryptoListEventInit extends CryptoListEvent {}

class CryptoListEventRefresh extends CryptoListEvent {}

class CryptoListEventSearch extends CryptoListEvent {
  final String text;

  CryptoListEventSearch(this.text);
}

class CryptoListEventAddDeposit extends CryptoListEvent {
  final DepositCrypto deposit;

  CryptoListEventAddDeposit({required this.deposit});
}

class CryptoListEventRemoveDeposit extends CryptoListEvent {
  final DepositCrypto deposit;

  CryptoListEventRemoveDeposit({required this.deposit});
}
