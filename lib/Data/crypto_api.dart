import 'dart:convert';
import 'dart:developer';
import 'package:hodler/Data/model/crypto.dart';
import 'package:hodler/Domain/Repository/crypto_repository_data.dart';
import 'package:http/http.dart' as http;

class CryptoAPI implements CryptoRepositoryData {
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
    try {
      Uri url = Uri.https("api.coingecko.com", '/api/v3/coins/markets', {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': "100",
        'page': "1",
        'sparkline': "false",
        'price_change_percentage': '24h,7d',
        'locale': "en",
        'precision': '3'
      });
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> listDirty = await jsonDecode(response.body);
        List<Crypto> out = [];
        for (var e in listDirty) {
          out.add(Crypto(
              id: e[fieldId],
              name: e[fieldName],
              acronym: e[fieldSymbol],
              price: e[fieldPrice],
              higth24: e[fieldHigth24],
              low24: e[fieldLow24],
              urlImage: e[fieldImage],
              changePrecent24: e[fieldChangePrecent24],
              changePrecent7Days: e[fieldChangePrecent7Days]));
        }

        return out;
      } else {
        log("eroor getAllCrypto code:${response.statusCode.toString()}\n ${response.headers.toString()}");
      }
    } catch (e) {
      log("error getAllCrypto ${e.toString()}");
    }
    return [];
  }

  @override
  Future<List<Crypto>> updateCrypto() {
    return getAllCrypto();
  }

  static Future<Crypto?> getCryptoByAcronym(String id) async {
    try {
      Uri url = Uri.https("api.coingecko.com", '/api/v3/coins/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonElement = await jsonDecode(response.body);
        Crypto el = Crypto(
            id: jsonElement["id"],
            name: jsonElement["name"],
            acronym: jsonElement["symbol"],
            price: jsonElement["current_price"]["usd"],
            higth24: jsonElement["high_24h"]["usd"],
            low24: jsonElement["low_24h"]["usd"],
            urlImage: jsonElement["image"]["small"],
            changePrecent24: jsonElement["price_change_percentage_24h"],
            changePrecent7Days: jsonElement["price_change_percentage_7d"]);
        return el;
      }
    } catch (e) {
      log("error getCryptoByAcronym ${e.toString()}");
    }
    return null;
  }

  @override
  Future<num> getCurrentValueCrypto({required String idCrypto}) async {
    try {
      Uri url = Uri.https("api.coingecko.com", '/api/v3/coins/$idCrypto', {
        'localization': 'false',
        'tickers': 'false',
        'market_data': 'true',
        'community_data': 'false',
        'developer_data': 'false',
        'sparkline': 'false',
      });
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonElement = await jsonDecode(response.body);
        return jsonElement["market_data"]["current_price"]["usd"];
      }
    } catch (e) {
      log("error getCryptoByAcronym ${e.toString()}");
    }
    return -1;
  }
}
