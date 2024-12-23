import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        content = AllergensToggle();
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
            const Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text("Let's get to know you"),
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
          const Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Text("How should we call you?"),
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
          const Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Text("How can we contact you?"),
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
          const Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Text("Where do you live?"),
              Text('This data will be used to give you recipes based on the weather.'),
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
}

class AllergensToggle extends StatefulWidget {
  @override
  _AllergensToggleState createState() => _AllergensToggleState();
}

class _AllergensToggleState extends State<AllergensToggle> {
  //TODO: create the list with allergens
  final List<String> allergens = [
    "Gluten",
    "Fish",
    "Nuts",
    "Eggs",
    "Mollusks",
    "Crustaceans",
    "Soy",
    "Milk"
  ];
//TODO: find the icons and put them in appicons
  final List<IconData> allergenIcons = [
    Icons.local_dining, // Gluten
    Icons.apple, // Fish
    Icons.nature, // Nuts
    Icons.fastfood, // Eggs
    Icons.pool, // Mollusks
    Icons.wine_bar, // Crustaceans
    Icons.spa, // Soy
    Icons.local_drink, // Milk
  ];

  final List<bool> _selected = List.generate(8, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Do you have allergens?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16.0),
        Wrap(
          spacing: 8.0, // Space between buttons
          runSpacing: 8.0, // Space between lines
          children: List.generate(allergens.length, (index) {
            return FilterChip(
              avatar: Icon(allergenIcons[index]), // Icon next to the label
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
        //TODO: add Next button
      ],
    );
  }
}
