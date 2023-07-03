import 'package:hodler/Data/model/crypto.dart';

abstract class CryptoRepositoryData {
  Future<List<Crypto>> getAllCrypto();
  Future<List<Crypto>> updateCrypto();
  Future<num> getCurrentValueCrypto({required String idCrypto});
}
