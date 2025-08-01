import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/model/recipe/preview.dart';
import 'package:client/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const KeskonMangeApp());
}

class KeskonMangeApp extends StatelessWidget {
  const KeskonMangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    RepositoriesManager().useMockRepositories(); // Set repositories to use
    return ChangeNotifierProvider(
      create: (context) => KeskonMangeState(),
      child: MaterialApp(
        title: 'KeskonMange',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Raleway",
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFABBC43)),
        ),
        home: LoginPage(),
        //home : HomePage(),
      ),
    );
  }
}

class KeskonMangeState extends ChangeNotifier {
  //for things that will be updated regularly
}
