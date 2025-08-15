import 'dart:convert';

import 'package:client/data/repositories/repositories_manager.dart';
import 'package:client/data/usecases/signup/activate_account_use_case.dart';
import 'package:client/data/usecases/signup/check_mail_availability_use_case.dart';
import 'package:client/data/usecases/signup/check_username_availability_use_case.dart';
import 'package:client/data/usecases/signup/create_account_use_case.dart';
import 'package:client/features/home/viewmodels/home_page_viewmodel.dart';
import 'package:client/features/user_signup/widgets/account_verification_step.dart';
import 'package:client/features/user_signup/widgets/allergens_step.dart';
import 'package:client/features/user_signup/widgets/username_step.dart';
import 'package:client/http/authentication.dart';
import 'package:client/http/sign_up/CreateAccountRequest.dart';
import 'package:client/features/home/views/home_page.dart';
import 'package:client/features/user_login/views/login_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:client/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../constants.dart';
import '../../../model/user.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../widgets/email_step.dart';
import '../widgets/post_code_step.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  ListView element = ListView();

  @override
  Widget build(BuildContext context) {
    SignupViewModel viewModel = Provider.of<SignupViewModel>(context);
    Widget content;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.isStepStateError) {
        String? message = viewModel.currentStepErrorMessage;
        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        }
      }
    });

    switch (viewModel.currentIndex) {
      case 0:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel,
          child: UsernameStep(),
        );
        break;
      case 1:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel,
          child: EmailStep(),
        );
        break;
      case 2:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel,
          child: PostCodeStep(),
        );
        break;
      case 3:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel,
          child: AllergensStep(),
        );
        break;
      case 4:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel,
          child: AccountVerificationStep(),
        );
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
              percent: viewModel.progressBarValue,
              lineHeight: 25,
              backgroundColor: AppColors.beige,
              progressColor: AppColors.kaki,
              barRadius: const Radius.circular(25.0),
              center: Text("${(viewModel.progressBarValue * 100).round()}%"),
              animation: true,
              animationDuration: 1000,
              animateFromLastPercent: true,
              onAnimationEnd: () {
                if (viewModel.signupFinalized) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                          create: (context) => HomePageViewModel(),
                          child: HomePage())));
                }
              },
            ),
            const SizedBox(height: 20),
            content,
            OverflowBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: viewModel.currentIndex == 0
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : viewModel.previousStep,
                  child: const Text('Go Back'),
                ),
                ElevatedButton(
                  onPressed: viewModel.nextStep,
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
