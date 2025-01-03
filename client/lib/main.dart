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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFABBC43)),
        ),
        home: LoginPage(),
      ),
    );
  }
}

class KeskonMangeState extends ChangeNotifier{
  //for things that will be updated regularly
}


