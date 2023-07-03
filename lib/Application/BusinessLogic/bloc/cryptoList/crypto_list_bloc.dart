import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hodler/Data/model/crypto.dart';
import 'package:hodler/Data/model/deposit_cypto.dart';
import 'package:hodler/Domain/Repository/crypto_repository_data.dart';
import 'package:hodler/Domain/Repository/hodler_repository_db.dart';
import 'package:hodler/core/utility.dart';

part 'crypto_list_event.dart';
part 'crypto_list_state.dart';

class CryptoListBloc extends Bloc<CryptoListEvent, CryptoListState> {
  List<Crypto> allList = [];
  final CryptoRepositoryData storage;
  final HolderRepositoryDB db;
  CryptoListBloc(this.storage, this.db) : super(CryptoListInitial()) {
    on<CryptoListEventInit>(_initAction);
    on<CryptoListEventRefresh>((event, emit) => emit(CryptoListInitial()));
    on<CryptoListEventSearch>(_searchAction);
    on<CryptoListEventAddDeposit>(_addDepositAction);
    on<CryptoListEventRemoveDeposit>(_removeDepositAction);
  }

  FutureOr<void> _initAction(
      CryptoListEventInit event, Emitter<CryptoListState> emit) async {
    await db.initDb();
    Utility.cryptoRepo = storage;
    allList = await storage.getAllCrypto();
    final List<DepositCrypto> listAllDeposit = await db.getAllDepositCrypto();
    final List<String> listIdCryptoDeposit =
        listAllDeposit.map((e) => e.idCrypto).toSet().toList();
    for (String i in listIdCryptoDeposit) {
      int indexCrypto = allList.indexWhere((element) => element.id == i);
      Crypto el = allList.elementAt(indexCrypto);
      List<DepositCrypto> listDeposit =
          listAllDeposit.where((element) => element.idCrypto == i).toList();
      num returnInvestiemnt =
          await Utility.calulateReturnInvestiment(deposit: listDeposit);
      num importInvestiment =
          await Utility.calculateTotalImport(deposit: listDeposit);
      allList.replaceRange(indexCrypto, indexCrypto + 1, [
        el.copyWith(
            deposit: listDeposit,
            analiticsInvestiment: importInvestiment,
            analiticsReturn: returnInvestiemnt)
      ]);
    }
    _emitCryptoListLoaded(emit, null);
  }

  FutureOr<void> _searchAction(
      CryptoListEventSearch event, Emitter<CryptoListState> emit) {
    final List<Crypto> filterList = allList
        .where((element) =>
            element.name.toUpperCase().contains(event.text.toUpperCase()) ||
            element.acronym.toUpperCase().contains(event.text.toUpperCase()))
        .toList();
    _emitCryptoListLoaded(emit, filterList);
  }

  FutureOr<void> _addDepositAction(
      CryptoListEventAddDeposit event, Emitter<CryptoListState> emit) async {
    int indexCrypto =
        allList.indexWhere((element) => element.id == event.deposit.idCrypto);
    db.addDeposit(event.deposit);
    Crypto crypto = allList.elementAt(indexCrypto);
    List<DepositCrypto> work = crypto.deposit;
    work.add(event.deposit);
    Crypto nCrypto = crypto.copyWith(
        deposit: work,
        analiticsInvestiment: await Utility.calculateTotalImport(deposit: work),
        analiticsReturn:
            await Utility.calulateReturnInvestiment(deposit: work));
    allList.replaceRange(indexCrypto, indexCrypto + 1, [nCrypto]);
    _emitCryptoListLoaded(emit, null);
  }

  FutureOr<void> _removeDepositAction(
      CryptoListEventRemoveDeposit event, Emitter<CryptoListState> emit) async {
    int indexCrypto =
        allList.indexWhere((element) => element.id == event.deposit.idCrypto);
    db.removeDeposit(event.deposit.idDeposit);
    Crypto crypto = allList.elementAt(indexCrypto);
    List<DepositCrypto> work = crypto.deposit;
    work.remove(event.deposit);
    Crypto nCrypto = crypto.copyWith(
        deposit: work,
        analiticsInvestiment: await Utility.calculateTotalImport(deposit: work),
        analiticsReturn:
            await Utility.calulateReturnInvestiment(deposit: work));
    allList.replaceRange(indexCrypto, indexCrypto + 1, [nCrypto]);
    _emitCryptoListLoaded(emit, null);
  }

  void _emitCryptoListLoaded(
      Emitter<CryptoListState> emit, List<Crypto>? list) {
    num totalImport = (list ?? allList).fold(
        0.0,
        ((previousValue, element) =>
            previousValue + element.analiticsInvestiment));
    num totalReturn = allList.fold(0.0,
        ((previousValue, element) => previousValue + element.analiticsReturn));
    emit(CryptoListLoaded(
        listCrypto: (list ?? allList),
        totalReturn: totalReturn,
        totalInvestiment: totalImport));
  }
}
