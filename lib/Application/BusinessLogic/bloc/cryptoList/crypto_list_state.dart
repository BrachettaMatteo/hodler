part of 'crypto_list_bloc.dart';

@immutable
abstract class CryptoListState {}

class CryptoListInitial extends CryptoListState {}

class CryptoListLoaded extends CryptoListState {
  final List<Crypto> listCrypto;
  final num totalInvestiment;
  final num totalReturn;
  CryptoListLoaded(
      {required this.listCrypto,
      required this.totalInvestiment,
      required this.totalReturn});
}
