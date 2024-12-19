import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _postcodeController = TextEditingController();

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
                onPressed: () {
                  if(_usernameController.text == "")return;
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
                onPressed: () {
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