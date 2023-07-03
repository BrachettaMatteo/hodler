import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hodler/Data/model/crypto.dart';
import 'insert_deposit_ui.dart';

class CriptoCardView extends StatefulWidget {
  final Crypto crypto;
  const CriptoCardView({super.key, required this.crypto});

  @override
  State<CriptoCardView> createState() => _CriptoCardViewState();
}

class _CriptoCardViewState extends State<CriptoCardView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _addDepositCrypto(),
        borderRadius: BorderRadius.circular(20),
        child: Card(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              _getTitleCard(),
              _getPriceCard(),
              _getAnalitics(),
              widget.crypto.deposit.isNotEmpty
                  ? _getDepositAnalitics()
                  : Container()
            ])));
  }

  Widget _getAnalitics() => IntrinsicHeight(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(children: [
                _getLabelAnaliticsValuePercent(
                    value: widget.crypto.changePrecent24),
                _getLabelAnaliticsValue(text: "today"),
              ]),
              _getVerticalDivider(),
              Column(children: [
                _getLabelAnaliticsValuePercent(
                    value: widget.crypto.changePrecent7Days),
                _getLabelAnaliticsValue(text: "week")
              ]),
            ]),
      );

  _addDepositCrypto() => showDialog<String>(
      context: context,
      builder: (BuildContext context) => InsertDepositUI(
            crypto: widget.crypto,
          ));

  Widget _getTitleCard() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.network(
              widget.crypto.urlImage,
              errorBuilder: (context, error, stackTrace) {
                log("CryptoCardView error load image ", error: error);
                return const Placeholder();
              },
            ),
          ),
          Column(
            children: [
              AutoSizeText("${widget.crypto.name} "),
              AutoSizeText(
                widget.crypto.acronym.toUpperCase(),
                style: TextStyle(color: Theme.of(context).dividerColor),
              )
            ],
          )
        ],
      );

  Widget _getPriceCard() => ListTile(
        title: AutoSizeText(
          "\$ ${widget.crypto.price.toString()}",
          style: const TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      );

  Widget _getLabelAnaliticsValuePercent({required double value}) => Text(
        "${value.toStringAsPrecision(2)}%",
        style: TextStyle(color: value > 0 ? Colors.green : Colors.red),
      );

  Widget _getLabelAnaliticsValue({required String text}) => Text(
        "Today".toUpperCase(),
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).hintColor),
      );

  Widget _getVerticalDivider() => const VerticalDivider(
        thickness: 1,
        width: 20,
      );

  Widget _getDepositAnalitics() => IntrinsicHeight(
        child: Column(
          children: [
            const Divider(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${widget.crypto.analiticsInvestiment.toStringAsFixed(2)}\$"),
                _getVerticalDivider(),
                Text("${widget.crypto.analiticsReturn.toStringAsFixed(2)} \$",
                    style: TextStyle(
                        color: widget.crypto.analiticsReturn > 0
                            ? Colors.green
                            : Colors.red))
              ],
            ),
          ],
        ),
      );
}
