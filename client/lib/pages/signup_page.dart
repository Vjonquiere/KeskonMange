import 'dart:convert';

import 'package:client/http/authentication.dart';
import 'package:client/pages/home_page.dart';
import 'package:client/pages/login_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../custom_widgets/colorful_text_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../constants.dart';
import '../http/sign_up/CreateAccountRequest.dart';
import '../http/sign_up/UserVerificationRequest.dart';
import '../http/sign_up/VerifyEmailRequest.dart';
import '../http/sign_up/VerifyUsernameRequest.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _postcodeController = TextEditingController();
  final storage = const FlutterSecureStorage();

  ListView element = ListView();
  var stateValue = 0.0;
  var step = 0;
  var nbSteps = 5;
  var signupFinalized = false;

  void nextStep() {
    setState(() {
      step += 1;
    });
  }

  void previousStep() {
    setState(() {
      step -= 1;
    });
  }

  double oneStep() {
    return 1 / nbSteps;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    // Use a switch statement to determine which widget to display
    switch (step) {
      case 0:
        content = usernameStep(context);
        break;
      case 1:
        content = emailStep(context);
        break;
      case 2:
        content = postCodeStep(context);
        break;
      case 3:
        content = AllergensToggle(this);
        break;
      case 4:
        CreateAccountRequest(_emailController.text, _usernameController.text)
            .send();
        content = accountVerification(context);
        break;
      default:
        content = const Center(child: Text("No more steps"));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                ColorfulTextBuilder("Let's get to know you!", 50, true)
                    .getWidget(),
              ],
            ),
            const SizedBox(height: 20.0),
            LinearPercentIndicator(
              percent: stateValue,
              lineHeight: 25,
              backgroundColor: AppColors.beige,
              progressColor: AppColors.kaki,
              barRadius: const Radius.circular(25.0),
              center: Text("${(stateValue * 100).round()}%"),
              animation: true,
              animationDuration: 1000,
              animateFromLastPercent: true,
              onAnimationEnd: () {
                if (signupFinalized)
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            const SizedBox(height: 20),

            content,
            // spacer
            const SizedBox(height: 12.0),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget usernameStep(BuildContext context) {
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("How should we call you?", 40).getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),

      // [username]
      TextField(
        controller: _usernameController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Username',
        ),
      ),
      const SizedBox(height: 20.0),

      OverflowBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            child: const Text('Go Back'),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          ElevatedButton(
            child: const Text('Next'),
            onPressed: () async {
              if (_usernameController.text == "") return;
              var isUsernameUnique =
                  await VerifyUsernameRequest(_usernameController.text).send();
              if (!(isUsernameUnique == 200)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Username is already taken'),
                  duration: Duration(milliseconds: 1500),
                ));
                return;
              }
              setState(() {
                step += 1;
                stateValue += oneStep();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Sending a request to server.'),
                  duration: Duration(milliseconds: 1500),
                ));
              });
            },
          ),
        ],
      ),
    ]);
  }

  Widget emailStep(BuildContext context) {
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("How can we contact you?", 40).getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      // [username]
      TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Email',
        ),
      ),
      const SizedBox(height: 20.0),
      OverflowBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            child: const Text('Go Back'),
            onPressed: () {
              setState(() {
                previousStep();
                stateValue -= oneStep();
              });
            },
          ),
          ElevatedButton(
            child: const Text('Next'),
            onPressed: () async {
              if (_emailController.text == "") return;
              final regex = RegExp((r'^[^\s@]+@[^\s@]+\.[^\s@]+$'));
              if (!regex.hasMatch(_emailController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Bad email.'),
                  duration: Duration(milliseconds: 1500),
                ));
                return;
              }
              var isEmailUnique =
                  await VerifyEmailRequest(_emailController.text).send();
              if (!(isEmailUnique == 200)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Email is already used'),
                  duration: Duration(milliseconds: 1500),
                ));
                return;
              }
              setState(() {
                step += 1;
                stateValue += oneStep();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Sending a request to server.'),
                  duration: Duration(milliseconds: 1500),
                ));
              });
            },
          ),
        ],
      ),
    ]);
  }

  Widget postCodeStep(BuildContext context) {
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("Where do you live?", 40).getWidget(),
          ColorfulTextBuilder(
                  'This data will be used to give you recipes based on the weather.',
                  20)
              .getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      // [username]
      TextField(
        controller: _postcodeController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Postcode',
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
          TextButton(
            child: const Text('Go Back'),
            onPressed: () {
              setState(() {
                previousStep();
                stateValue -= oneStep();
              });
            },
          ),
          ElevatedButton(
            child: const Text('Next'),
            onPressed: () {
              if (_postcodeController.text == "") return;
              setState(() {
                step += 1;
                stateValue += oneStep();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Sending a request to server.'),
                  duration: Duration(milliseconds: 1500),
                ));
              });
            },
          ),
        ],
      ),
    ]);
  }

  Widget accountVerification(BuildContext context) {
    final verificationCodeController = TextEditingController();
    return Column(children: <Widget>[
      Column(
        children: <Widget>[
          const SizedBox(height: 16.0),
          ColorfulTextBuilder("Let's finalise the setup!", 40).getWidget(),
          ColorfulTextBuilder('Enter the code we have sent by mail', 20)
              .getWidget(),
        ],
      ),
      const SizedBox(height: 20.0),
      // [username]
      TextField(
        controller: verificationCodeController,
        decoration: const InputDecoration(
          filled: true,
          labelText: 'Code (via mail)',
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
          ElevatedButton(
            child: const Text('Next'),
            onPressed: () async {
              if (verificationCodeController.text == "") return;
              var verificationRequest = UserVerificationRequest(
                  _emailController.text, verificationCodeController.text);
              if (!(await verificationRequest.send() == 200)) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Verification code is not valid"),
                  duration: Duration(milliseconds: 1500),
                ));
                return;
              }
              final apiKey = jsonDecode(verificationRequest.getBody())
                  as Map<String, dynamic>;
              if (apiKey.containsKey('token')) {
                await Authentication().updateCredentialsFromStorage(
                    apiKey["token"],
                    _emailController.text,
                    _usernameController.text);
                await Authentication().refreshCredentialsFromStorage();
              }
              setState(() {
                signupFinalized = true;
                stateValue += oneStep();
              });
            },
          ),
        ],
      ),
    ]);
  }
}

class AllergensToggle extends StatefulWidget {
  final _SignupPageState _signupPageState;
  const AllergensToggle(this._signupPageState);

  @override
  _AllergensToggleState createState() =>
      _AllergensToggleState(_signupPageState);
}

class _AllergensToggleState extends State<AllergensToggle> {
  final _SignupPageState _signupPageState;
  final List<bool> _selected = List.generate(14, (_) => false);

  _AllergensToggleState(this._signupPageState);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColorfulTextBuilder("Do you have allergens?", 40).getWidget(),
        const SizedBox(height: 16.0),
        Wrap(
          spacing: 8.0, // Space between buttons
          runSpacing: 8.0, // Space between lines
          children: List.generate(allergens.length, (index) {
            return FilterChip(
              avatar: SvgPicture.asset(AppIcons.getIcon(allergens[index])),
              label: Text(allergens[index]),
              selected: _selected[index],
              onSelected: (bool selected) {
                setState(() {
                  _selected[index] = selected;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 20.0),
        OverflowBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: const Text('Go Back'),
              onPressed: () {
                setState(() {
                  _signupPageState.previousStep();
                  _signupPageState.stateValue -= _signupPageState.oneStep();
                });
              },
            ),
            ElevatedButton(
              child: const Text('Next'),
              onPressed: () {
                setState(() {
                  _signupPageState.stateValue += _signupPageState.oneStep();
                  _signupPageState.nextStep();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Sending a request to server.'),
                    duration: Duration(milliseconds: 1500),
                  ));
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
