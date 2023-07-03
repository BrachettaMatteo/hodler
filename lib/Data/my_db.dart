import 'package:hodler/Domain/Repository/hodler_repository_db.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'model/deposit_cypto.dart';

class MyDB implements HolderRepositoryDB {
  late final Database db;
  @override
  Future<void> initDb() async {
    var databaseFactory = databaseFactoryFfi;
    db = await databaseFactory.openDatabase(
      join(await databaseFactoryFfi.getDatabasesPath(),
          HolderRepositoryDB.nameDB),
      options: OpenDatabaseOptions(
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
              """
          CREATE TABLE ${HolderRepositoryDB.nameTableDB}(
            ${HolderRepositoryDB.fieldId} TEXT PRIMARY KEY,
            ${HolderRepositoryDB.fieldIdCrypto} TEXT NOT NULL,
            ${HolderRepositoryDB.fieldImport} REAL NOT NULL,
            ${HolderRepositoryDB.fieldValueWhenBuy} REAL NOT NULL,
            ${HolderRepositoryDB.fieldDate} INTEGER NOT NULL
           )
        """,
            );
          }),
    );
  }

  @override
  Future<bool> addDeposit(DepositCrypto newDeposit) async {
    final result =
        await db.insert(HolderRepositoryDB.nameTableDB, newDeposit.toJson());
    return result != 0;
  }

  @override
  Future<List<DepositCrypto>> getAllDepositCrypto() async {
    final List<Map<String, dynamic>> result =
        await db.query(HolderRepositoryDB.nameTableDB);
    List<DepositCrypto> out = [];
    for (var element in result) {
      out.add(DepositCrypto.fromJson(element));
    }
    return out;
  }

  @override
  Future<List<DepositCrypto>> getDepositByCrypto(String cryptoAcronym) async {
    final List<Map<String, dynamic>> result = await db.query(
        HolderRepositoryDB.nameTableDB,
        where: "${HolderRepositoryDB.fieldAcronym}= ?",
        whereArgs: [cryptoAcronym]);

    return result.map((e) => DepositCrypto.fromJson(e)).toList();
  }

  @override
  Future<bool> removeDeposit(String idDeposit) async {
    final int result = await db.delete(HolderRepositoryDB.nameTableDB,
        where: "${HolderRepositoryDB.fieldId}= ?", whereArgs: [idDeposit]);
    return result == 1;
  }
}
