import 'package:client/home_page.dart';
import 'package:client/http/sign_up/account_creation.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colorful_text_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'constants.dart';
import 'http/sign_up/verify_data.dart';
class SignupPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _postcodeController = TextEditingController();

  List<String> _userAllergens = <String>[];

  ListView element=ListView();
  var stateValue = 0.0;
  var step = 0;

  void nextStep(){
    setState(() {
      step += 1;
    });
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
        CreateAccountRequest(_emailController.text, _usernameController.text).request();
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
                ColorfulTextBuilder("Let's get to know you", 50, true).getWidget(),
              ],
            ),
            const SizedBox(height: 20.0),
            LinearProgressIndicator(
              value: stateValue,
              minHeight: 25.0,
              borderRadius: BorderRadius.circular(25.0),
              semanticsLabel: 'Linear progress indicator',
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

  Widget usernameStep(BuildContext context){
    return Column(
        children: <Widget>[
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
              ElevatedButton(
                child: const Text('Next'),
                onPressed: () async {
                  if(_usernameController.text == "")return;
                  var isUsernameUnique = await VerifyUsernameRequest(_usernameController.text).request();
                  if (!isUsernameUnique) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Username is already taken'),
                          duration: Duration(milliseconds: 1500),
                        ));
                    return;
                  }
                  setState(() {
                    step+=1;
                    stateValue=0.3;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending a request to server.'),
                          duration: Duration(milliseconds: 1500),
                        ));
                  });
                },
              ),
            ],
          ),
        ]
      );
  }

  Widget emailStep(BuildContext context){
    return Column(
        children: <Widget>[
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
              ElevatedButton(
                child: const Text('Next'),
                onPressed: () async {
                  if(_emailController.text == "")return;
                  final regex = RegExp((r'^[^\s@]+@[^\s@]+\.[^\s@]+$'));
                  if(!regex.hasMatch(_emailController.text)){
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bad email.'),
                          duration: Duration(milliseconds: 1500),
                        ));
                    return;
                  }
                  var isEmailUnique = await VerifyEmailRequest(_emailController.text).request();
                  if (!isEmailUnique) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email is already used'),
                          duration: Duration(milliseconds: 1500),
                        ));
                    return;
                  }
                  setState(() {
                    step+=1;
                    stateValue+=0.3;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending a request to server.'),
                          duration: Duration(milliseconds: 1500),
                        ));
                  });
                },
              ),
            ],
          ),
        ]
    );
  }

  Widget postCodeStep(BuildContext context){
    return Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 16.0),
              ColorfulTextBuilder("Where do you live?", 40).getWidget(),
              ColorfulTextBuilder('This data will be used to give you recipes based on the weather.', 20).getWidget(),
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
              ElevatedButton(
                child: const Text('Next'),
                onPressed: () {
                  if(_postcodeController.text == "")return;
                  setState(() {
                    step+=1;
                    stateValue+=0.3;
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sending a request to server.'),
                          duration: Duration(milliseconds: 1500),
                        ));
                  });
                },
              ),
            ],
          ),
        ]
    );
  }

Widget accountVerification(BuildContext context) {
  final verificationCodeController = TextEditingController();
  return Column(
      children: <Widget>[
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
                var verificationRequest = UserVerificationRequest(_emailController.text, verificationCodeController.text);
                if (!(await verificationRequest.request())){
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                  content: Text("Verification code is not valid"),
                  duration: Duration(milliseconds: 1500),
                  ));
                  return;
                }
                // TODO: save the token in storage
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
      ]
  );
}
}

class AllergensToggle extends StatefulWidget {
  final _SignupPageState _signupPageState;
  const AllergensToggle(this._signupPageState);

  @override
  _AllergensToggleState createState() => _AllergensToggleState(_signupPageState);
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
            ElevatedButton(
              child: const Text('Next'),
              onPressed: () {
                setState(() {
                  _signupPageState.nextStep();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sending a request to server.'),
                        duration: Duration(milliseconds: 1500),
                      ));
                });
              },
            ),
          ],
        ),
        //TODO: add Next button
      ],
    );
  }
}