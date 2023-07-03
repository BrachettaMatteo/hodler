import 'package:hodler/Data/model/deposit_cypto.dart';
import 'package:hodler/Domain/Repository/crypto_repository_data.dart';

class Utility {
  static CryptoRepositoryData? cryptoRepo;

  /// formula: (Initial Investment — Investment Fee) * ( Sell Price / Buy price) — Initial Investment — Exit Fee
  /// credits fomula: https://coincodex.com/profit-calculator/
  num getGrainDeposit(DepositCrypto deposit, num valueCrypto) {
    return (deposit.importDeposit) * (valueCrypto / deposit.costCrypto) -
        deposit.importDeposit;
  }

  static Future<num> calulateReturnInvestiment(
      {required List<DepositCrypto> deposit}) async {
    num returnInvestiemnt = 0;
    for (DepositCrypto dp in deposit) {
      final currentValue = await Utility.cryptoRepo!
          .getCurrentValueCrypto(idCrypto: dp.idCrypto);
      returnInvestiemnt += Utility().getGrainDeposit(dp, currentValue);
    }
    return returnInvestiemnt;
  }

  static Future<num> calculateTotalImport(
      {required List<DepositCrypto> deposit}) async {
    num totalIvestiment = 0;
    for (DepositCrypto dp in deposit) {
      totalIvestiment += dp.importDeposit;
    }
    return totalIvestiment;
  }
}
