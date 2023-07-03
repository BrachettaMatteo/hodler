import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hodler/Application/BusinessLogic/bloc/cryptoList/crypto_list_bloc.dart';
import 'package:hodler/Application/Presentation/HomePage/components/crypto_card_view.dart';
import '../../../Data/model/crypto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 2,
          titleSpacing: 20,
          centerTitle: true,
          title: _searchBar(),
        ),
        body: BlocBuilder<CryptoListBloc, CryptoListState>(
            builder: (context, state) {
          if (state is CryptoListLoaded) {
            List<Crypto> listCrypto = state.listCrypto;
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) =>
                    CriptoCardView(crypto: listCrypto[index]),
                itemCount: listCrypto.length);
          }
          return const Center(child: CircularProgressIndicator());
        }),
        bottomNavigationBar: _getFooter());
  }

  Widget _searchBar() => SearchBar(
        constraints: BoxConstraints.tight(
            Size(MediaQuery.of(context).size.width * 0.5, 45)),
        controller: _searchController,
        hintText: "search crypto",
        leading: const Icon(Icons.search),
        hintStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 15)),
        onChanged: (value) => _updateList(),
      );

  void _updateList() => BlocProvider.of<CryptoListBloc>(context)
      .add(CryptoListEventSearch(_searchController.text.trim()));

  Widget _getFooter() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<CryptoListBloc, CryptoListState>(
              builder: (context, state) {
            if (state is CryptoListLoaded) {
              return _getElementFooter(
                  title: "controll Line",
                  analiticsInvestiment: state.totalInvestiment.floorToDouble(),
                  analiticsReturn: state.totalReturn.ceilToDouble());
            }
            return const Center(child: Text("notFound"));
          }),
        ],
      );

  Widget _getElementFooter(
          {required String title,
          required double analiticsInvestiment,
          required double analiticsReturn}) =>
      Container(
        color: Colors.grey.shade300,
        child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            title: Text(
              title.toUpperCase(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getAnalitics(
                    titleAnalistics: "investiment",
                    importAnalitics: analiticsInvestiment,
                    colorTextImport: Colors.red),
                const VerticalDivider(width: 20),
                _getAnalitics(
                    titleAnalistics: "return",
                    importAnalitics: analiticsReturn,
                    colorTextImport: Colors.green)
              ],
            )),
      );

  Widget _getAnalitics(
          {required String titleAnalistics,
          required num importAnalitics,
          required Color? colorTextImport}) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(titleAnalistics.toUpperCase()),
        Text("${importAnalitics.toStringAsFixed(3)} \$",
            style: TextStyle(fontSize: 15, color: colorTextImport)),
      ]);
}
