import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hodler/Data/crypto_api.dart';
import 'package:hodler/Data/model/crypto.dart';
import 'package:hodler/Domain/Repository/crypto_repository_data.dart';

class CryptoAPILocal implements CryptoRepositoryData {
  final String fieldId = "id";
  final String fieldName = "name";
  final String fieldSymbol = "symbol";
  final String fieldImage = "image";
  final String fieldPrice = "current_price";
  final String fieldHigth24 = "high_24h";
  final String fieldLow24 = "low_24h";
  final String fieldChangePrecent24 = "price_change_percentage_24h_in_currency";
  final String fieldChangePrecent7Days =
      "price_change_percentage_7d_in_currency";

  @override
  Future<List<Crypto>> getAllCrypto() async {
    final String response = await rootBundle.loadString('assets/data.json');
    List<dynamic> listDirty = await jsonDecode(response);

    return listDirty.map((element) {
      Crypto el = Crypto(
          id: element[fieldId],
          name: element[fieldName],
          acronym: element[fieldSymbol],
          price: element[fieldPrice],
          higth24: element[fieldHigth24],
          low24: element[fieldLow24],
          urlImage: element[fieldImage],
          changePrecent24: element[fieldChangePrecent24],
          changePrecent7Days: element[fieldChangePrecent7Days]);
      return el;
    }).toList();
  }

  @override
  Future<List<Crypto>> updateCrypto() {
    return getAllCrypto();
  }

  static Future<Crypto?> getCryptoByAcronym(String id) async {
    final String response = await rootBundle.loadString('assets/data.json');
    List<Map<String, dynamic>> listDirty = await jsonDecode(response);
    Map<String, dynamic> elfind =
        listDirty.where((element) => element[CryptoAPI().fieldId] == id).first;
    if (elfind.isNotEmpty) {
      return Crypto(
          id: elfind[CryptoAPI().fieldId],
          name: elfind[CryptoAPI().fieldName],
          acronym: elfind[CryptoAPI().fieldSymbol],
          price: elfind[CryptoAPI().fieldPrice],
          higth24: elfind[CryptoAPI().fieldHigth24],
          low24: elfind[CryptoAPI().fieldLow24],
          urlImage: elfind[CryptoAPI().fieldImage],
          changePrecent24: elfind[CryptoAPI().fieldChangePrecent24],
          changePrecent7Days: elfind[CryptoAPI().fieldChangePrecent7Days]);
    }
    return null;
  }

  @override
  Future<num> getCurrentValueCrypto({required String idCrypto}) async {
    final String response = await rootBundle.loadString('assets/data.json');
    List<dynamic> listDirty = await jsonDecode(response);

    Map<String, dynamic> elfind = listDirty
        .where((element) => element[CryptoAPI().fieldId] == idCrypto)
        .first;
    return elfind[fieldPrice];
  }
}
