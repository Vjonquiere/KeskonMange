import 'package:client/pages/home_page.dart';
import 'package:client/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/custom_widgets/colorful_text_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../http/sign_in.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage(); // Where API key is stored

  var signInPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  async {
      String? API_KEY = await storage.read(key: 'API_KEY');
      String? email = await storage.read(key: 'EMAIL');
        if (API_KEY != null && email != null){ // If an API key is present just pass Authentication
          var req = CheckAPIKeyValidity(email, API_KEY);
          var code = await req.request();
          if (code == 200){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage())); //TODO: Check on key validity
          } else {
            await storage.delete(key: 'API_KEY');
            await storage.read(key: 'EMAIL');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(req.body),
                  duration: const Duration(milliseconds: 1500),
                ));
          }
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
            if(signInPressed)
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
                if(!signInPressed)
                  TextButton(
                    child: const Text('Sign up'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                  ),
                if(signInPressed)
                  TextButton(
                    child: const Text('Go Back'),
                    onPressed: () {
                      setState(() {
                        signInPressed=false;
                      });
                    },
                  ),
                ElevatedButton(
                  child: const Text('Sign in'),
                  onPressed: () async {
                    if(_emailController.text == "")return;
                    if(signInPressed){
                      var verifyCode = VerifyAuthenticationCode(_emailController.text, _passwordController.text);
                      if (!(await verifyCode.request())){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(verifyCode.body),
                              duration: const Duration(milliseconds: 1500),
                            ));
                        return;
                      }
                      final apiKey = jsonDecode(verifyCode.body) as Map<String, dynamic>;
                      if (apiKey.containsKey('token')){
                        await storage.write(key: 'API_KEY', value: apiKey["token"]); // Put the API key in storage
                        await storage.write(key: 'EMAIL', value: _emailController.text);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                      }
                      return;
                    }
                    var sendCode =  GetAuthenticationCode(_emailController.text);
                    if(!(await sendCode.request())){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(sendCode.body),
                            duration: const Duration(milliseconds: 1500),
                          ));
                      return;
                    }
                    setState(() {
                      signInPressed = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
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
        ),
      ),
    );
  }
}