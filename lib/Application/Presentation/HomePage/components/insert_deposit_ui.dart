import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hodler/Application/BusinessLogic/bloc/cryptoList/crypto_list_bloc.dart';
import 'package:hodler/Data/model/crypto.dart';
import 'package:hodler/Data/model/deposit_cypto.dart';
import 'package:uuid/uuid.dart';

class InsertDepositUI extends StatefulWidget {
  final Crypto crypto;
  const InsertDepositUI({super.key, required this.crypto});

  @override
  State<InsertDepositUI> createState() => _InsertDepositUIState();
}

class _InsertDepositUIState extends State<InsertDepositUI> {
  late TextEditingController _importController;
  late TextEditingController _costCryptoController;
  late GlobalKey<FormState> _globalKey;

  @override
  void initState() {
    _importController = TextEditingController();
    _costCryptoController = TextEditingController();
    _globalKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    _importController.dispose();
    _costCryptoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Form(
            key: _globalKey,
            child: Column(children: [
              SizedBox(
                width: 300,
                child: ListTile(
                  title: Text("Add Deposit",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Text(widget.crypto.name),
                      CircleAvatar(
                        radius: 10,
                        child: Image.network(widget.crypto.urlImage),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              _getInputImportField(),
              _getInputImportCostField()
            ])),
        ElevatedButton(
            onPressed: () => _addDeposit(), child: const Text("add deposit")),
        const SizedBox(height: 100),
        _getDepositSection()
      ]),
    );
  }

  Widget _getDepositSection() => Expanded(
        child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("List Deposit",
                    style: Theme.of(context).textTheme.titleLarge),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("import deposit"),
                    SizedBox(width: 20),
                    Text("cost crypto")
                  ],
                ),
                Expanded(
                    child: widget.crypto.deposit.isNotEmpty
                        ? _getDepositListView(deposit: widget.crypto.deposit)
                        : const Center(
                            child: Text("not deposit"),
                          ))
              ],
            )),
      );

  void _addDeposit() {
    if (_globalKey.currentState!.validate()) {
      DepositCrypto deposit = DepositCrypto(
          idDeposit: const Uuid().v4(),
          idCrypto: widget.crypto.id,
          importDeposit: double.parse(_importController.text),
          costCrypto: double.parse(_costCryptoController.text));
      BlocProvider.of<CryptoListBloc>(context)
          .add(CryptoListEventAddDeposit(deposit: deposit));
      _costCryptoController.clear();
      _importController.clear();
    }
  }

  String? _validator(value) {
    if (value == null || value.isEmpty) return "insert import";
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return "import not vaid";
    }
    return null;
  }

  void _deleteDeposit({required DepositCrypto deposit}) =>
      BlocProvider.of<CryptoListBloc>(context)
          .add(CryptoListEventRemoveDeposit(deposit: deposit));

  Widget _getDepositListView({required List<DepositCrypto> deposit}) =>
      ListView.separated(
        itemBuilder: (context, index) {
          DepositCrypto dp = deposit[index];
          return Dismissible(
            key: Key(dp.idDeposit),
            onDismissed: (direction) => _deleteDeposit(deposit: deposit[index]),
            background: Container(
                color: Colors.red,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_getIconTrash(), _getIconTrash()])),
            child: ListTile(
                title: Text("${dp.importDeposit.toStringAsFixed(2)}\$"),
                trailing: Text("${dp.costCrypto.toStringAsFixed(4)}\$")),
          );
        },
        itemCount: deposit.length,
        separatorBuilder: (_, __) => const Divider(),
      );

  Icon _getIconTrash() =>
      const Icon(FontAwesomeIcons.solidTrashCan, color: Colors.white);

  _getInputImportField() => IntrinsicWidth(
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: _importController,
          validator: (value) => _validator(value),
          style: const TextStyle(fontSize: 30),
          decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(FontAwesomeIcons.dollarSign),
              hintText: "Investiment"),
        ),
      );

  _getInputImportCostField() => IntrinsicWidth(
        child: TextFormField(
          controller: _costCryptoController,
          keyboardType: TextInputType.number,
          validator: (value) => _validator(value),
          style: const TextStyle(fontSize: 30),
          decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(FontAwesomeIcons.dollarSign),
              hintText: "cost cyrpto"),
        ),
      );
}
