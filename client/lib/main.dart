import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/features/user_login/viewmodels/login_page_viewmodel.dart';
import 'package:client/features/user_login/views/login_page.dart';
import 'package:client/utils/mock_repositories_sample_load.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const KeskonMangeApp());
}

class KeskonMangeApp extends StatelessWidget {
  const KeskonMangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    RepositoriesManager().useMockRepositories();

    return FutureBuilder<MockRepositoriesSampleLoad>(
      future: RepositoriesManager().currentlyUsingMockRepositories
          ? MockRepositoriesSampleLoad.create()
          : Future.value(null),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        return MaterialApp(
          title: 'KeskonMange',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('fr','FR'),
          ],
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: "Raleway",
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFFABBC43)),
          ),
          home: ChangeNotifierProvider(
            create: (context) => LoginPageViewModel(),
            child: LoginPage(),
          ),
        );
      },
    );
  }
}
