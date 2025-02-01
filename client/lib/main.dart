import 'package:client/pages/home_page.dart';
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
