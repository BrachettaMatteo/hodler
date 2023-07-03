import '../../Data/model/deposit_cypto.dart';

abstract class HolderRepositoryDB {
  static const String nameDB = "holder.db";
  static const String nameTableDB = "hodlerDeposit";

  static const String fieldId = "id";
  static const String fieldAcronym = "acronym";
  static const String fieldDate = "date";
  static const String fieldImport = "import";
  static const String fieldValueWhenBuy = "valueBuy";

  static const String fieldIdCrypto = "idCrypto";

  Future<void> initDb();
  Future<List<DepositCrypto>> getAllDepositCrypto();
  Future<bool> addDeposit(DepositCrypto newDeposit);
  Future<bool> removeDeposit(String idDeposit);
  Future<List<DepositCrypto>> getDepositByCrypto(String cryptoNameOrAcronym);
}
