import 'package:flutter/widgets.dart';
import 'package:hodler/Data/model/deposit_cypto.dart';

@immutable
class Crypto {
  final String id;
  final String acronym;
  final num price;
  final num? higth24;
  final num? low24;
  final String urlImage;
  final double changePrecent24;
  final double changePrecent7Days;
  final String name;
  final List<DepositCrypto> deposit;
  final num analiticsInvestiment;
  final num analiticsReturn;

  const Crypto({
    required this.id,
    required this.name,
    required this.acronym,
    required this.price,
    required this.higth24,
    required this.low24,
    required this.urlImage,
    required this.changePrecent24,
    required this.changePrecent7Days,
    this.deposit = const [],
    this.analiticsInvestiment = 0,
    this.analiticsReturn = 0,
  });

  Crypto copyWith(
          {String? id,
          String? acronym,
          num? price,
          num? higth24,
          num? low24,
          String? urlImage,
          double? changePrecent24,
          double? changePrecent7Days,
          String? name,
          List<DepositCrypto>? deposit,
          num? analiticsInvestiment,
          num? analiticsReturn}) =>
      Crypto(
          id: id ?? this.id,
          name: name ?? this.name,
          acronym: acronym ?? this.acronym,
          price: price ?? this.price,
          higth24: higth24,
          low24: low24,
          urlImage: urlImage ?? this.urlImage,
          changePrecent24: changePrecent24 ?? this.changePrecent24,
          changePrecent7Days: changePrecent7Days ?? this.changePrecent7Days,
          deposit: deposit ?? this.deposit,
          analiticsInvestiment:
              analiticsInvestiment ?? this.analiticsInvestiment,
          analiticsReturn: analiticsReturn ?? this.analiticsReturn);

  @override
  String toString() {
    StringBuffer buffer = StringBuffer()
      ..writeln("\t info Crypto")
      ..writeln("id: $id")
      ..writeln("name: $name")
      ..writeln("acronym: $acronym")
      ..writeln("price: ${price.toString()}")
      ..writeln("H24: ${higth24.toString()}")
      ..writeln("L24: ${low24.toString()}")
      ..writeln("url image: $urlImage")
      ..writeln("change%24: ${changePrecent24.toString()}")
      ..writeln("change%7d: ${changePrecent7Days.toString()}")
      ..writeln("deposit: ${deposit.toString()}")
      ..writeln("analitcs return: ${analiticsReturn.toString()}")
      ..writeln("analitics invest: ${analiticsInvestiment.toString()} ");
    return buffer.toString();
  }
}
