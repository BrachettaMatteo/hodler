import '../../Domain/Repository/hodler_repository_db.dart';

class DepositCrypto {
  final String idDeposit;
  final String idCrypto;
  final double importDeposit;
  final num costCrypto;

  DepositCrypto(
      {required this.idDeposit,
      required this.idCrypto,
      required this.importDeposit,
      required this.costCrypto});

  DepositCrypto copyWith(
          {String? idDeposit,
          String? idCrypto,
          double? importDeposit,
          num? costCrypto}) =>
      DepositCrypto(
          idDeposit: idDeposit ?? this.idDeposit,
          idCrypto: idCrypto ?? this.idCrypto,
          importDeposit: importDeposit ?? this.importDeposit,
          costCrypto: costCrypto ?? this.costCrypto);

  factory DepositCrypto.fromJson(Map<String, dynamic> json) => DepositCrypto(
      idDeposit: json[HolderRepositoryDB.fieldId],
      idCrypto: json[HolderRepositoryDB.fieldIdCrypto],
      importDeposit: json[HolderRepositoryDB.fieldImport],
      costCrypto: json[HolderRepositoryDB.fieldValueWhenBuy]);

  Map<String, dynamic> toJson() => {
        HolderRepositoryDB.fieldId: idDeposit,
        HolderRepositoryDB.fieldIdCrypto: idCrypto,
        HolderRepositoryDB.fieldImport: importDeposit,
        HolderRepositoryDB.fieldValueWhenBuy: costCrypto,
        HolderRepositoryDB.fieldDate: DateTime.now().millisecondsSinceEpoch
      };

  @override
  String toString() {
    StringBuffer stringBuffer = StringBuffer()
      ..writeln("\t Deposit crypto")
      ..writeln("id: $idDeposit")
      ..writeln("idCrypto: $idCrypto")
      ..writeln("importDeposit: $importDeposit")
      ..writeln("costBut: $costCrypto");
    return stringBuffer.toString();
  }
}
