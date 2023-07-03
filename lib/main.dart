import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hodler/Application/Presentation/HomePage/home_page.dart';
import 'package:hodler/Data/crypto_api_local.dart';
import 'package:hodler/Data/my_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'Application/BusinessLogic/bloc/cryptoList/crypto_list_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => CryptoListBloc(CryptoAPILocal(), MyDB())),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<CryptoListBloc>(context).add(CryptoListEventInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hodler',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}
