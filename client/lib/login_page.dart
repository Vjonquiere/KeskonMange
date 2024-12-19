import 'package:client/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var signInPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            const Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('KeskonMange'),
              ],
            ),
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
                  onPressed: () {
                    if(_emailController.text == "")return;
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