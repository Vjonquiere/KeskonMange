import 'package:client/core/widget_states.dart';
import 'package:client/features/user_login/viewmodels/login_page_viewmodel.dart';
import 'package:client/features/home/views/home_page.dart';
import 'package:client/features/user_signup/viewmodels/signup_viewmodel.dart';
import 'package:client/features/user_signup/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginPageViewModel viewModel = Provider.of<LoginPageViewModel>(context);
    return Scaffold(
        body: SafeArea(
            child: switch (viewModel.state) {
      WidgetStates.idle => const CircularProgressIndicator(),
      WidgetStates.loading => const CircularProgressIndicator(),
      WidgetStates.ready => loginPage(context, viewModel),
      WidgetStates.error => const Text("Error"),
    }));
  }

  Widget loginPage(BuildContext context, LoginPageViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      }

      if (viewModel.userLogged == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    });

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        const SizedBox(height: 80.0),
        ColorfulTextBuilder("KeskonMange", 50, true).getWidget(),
        const SizedBox(height: 120.0),
        // [Email]
        TextField(
          controller: viewModel.emailController,
          decoration: const InputDecoration(
            filled: true,
            labelText: 'Email',
          ),
        ),
        const SizedBox(height: 20.0),
        if (viewModel.signInPressed)
          TextField(
            controller: viewModel.passwordController,
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
            if (!viewModel.signInPressed)
              TextButton(
                child: const Text('Sign up'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                          create: (context) => SignupViewModel(),
                          child: SignupPage())));
                },
              ),
            if (viewModel.signInPressed)
              TextButton(
                child: const Text('Go Back'),
                onPressed: viewModel.onBackButtonPressed,
              ),
            ElevatedButton(
              child: const Text('Sign in'),
              onPressed: viewModel.onSignInPressed,
            ),
          ],
        ),

        // spacer
        const SizedBox(height: 12.0),
      ],
    );
  }
}
