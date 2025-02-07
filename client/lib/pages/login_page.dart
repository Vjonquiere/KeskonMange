import 'package:client/http/authentication.dart';
import 'package:client/http/sign_in/CheckAPIKeyValidityRequest.dart';
import 'package:client/http/sign_in/GetAuthenticationCodeRequest.dart';
import 'package:client/http/sign_in/VerifyAuthenticationCodeRequest.dart';
import 'package:client/http/user/GetUserInfos.dart';
import 'package:client/pages/home_page.dart';
import 'package:client/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/custom_widgets/colorful_text_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage(); // Where API key is stored

  var signInPressed = false;
  late Future<int> userLogged;

  @override
  void initState() {
    super.initState();
    userLogged = checkUserAuth();
  }

  Future<int> checkUserAuth() async {
    if (!(await Authentication().initCredentialsFromStorage())) {
      await Authentication()
          .deleteCredentialsFromStorage(); // Credentials are missing, don't try to check their validity
      return -1;
    }
    String API_KEY = Authentication().getCredentials().api_key;
    String email = Authentication().getCredentials().email;
    var req = CheckAPIKeyValidityRequest(email, API_KEY);
    return req.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<int>(
              future: userLogged,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data! == 200) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    });
                    return const SizedBox();
                  } else {
                    return loginPage(context);
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })),
    );
  }

  Widget loginPage(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        const SizedBox(height: 80.0),
        ColorfulTextBuilder("KeskonMange", 50, true).getWidget(),
        const SizedBox(height: 120.0),
        // [Email]
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Email',
          ),
        ),
        const SizedBox(height: 20.0),
        if (signInPressed)
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Code (via email)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),

        const SizedBox(height: 20.0),
        OverflowBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!signInPressed)
              TextButton(
                child: const Text('Sign up'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
              ),
            if (signInPressed)
              TextButton(
                child: const Text('Go Back'),
                onPressed: () {
                  setState(() {
                    signInPressed = false;
                  });
                },
              ),
            ElevatedButton(
              child: const Text('Sign in'),
              onPressed: () async {
                if (_emailController.text == "") return;
                if (signInPressed) {
                  var verifyCode = VerifyAuthenticationCodeRequest(
                      _emailController.text, _passwordController.text);
                  if (!(await verifyCode.send() == 200)) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(verifyCode.getBody()),
                      duration: const Duration(milliseconds: 1500),
                    ));
                    return;
                  }
                  final apiKey =
                      jsonDecode(verifyCode.getBody()) as Map<String, dynamic>;
                  if (apiKey.containsKey('token') &&
                      apiKey.containsKey('username')) {
                    await Authentication().updateCredentialsFromStorage(
                        apiKey["token"],
                        _emailController.text,
                        apiKey["username"]);
                    await Authentication().refreshCredentialsFromStorage();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }
                  return;
                }
                var sendCode =
                    GetAuthenticationCodeRequest(_emailController.text);
                if (!(await sendCode.send() == 200)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(sendCode.getBody()),
                    duration: const Duration(milliseconds: 1500),
                  ));
                  return;
                }
                setState(() {
                  signInPressed = true;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Code sent to email.'),
                    duration: Duration(milliseconds: 1500),
                  ));
                });
              },
            ),
          ],
        ),

        // spacer
        const SizedBox(height: 12.0),
      ],
    );
  }
}
