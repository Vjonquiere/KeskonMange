
import 'package:client/features/home/viewmodels/home_page_viewmodel.dart';
import 'package:client/features/user_signup/widgets/account_verification_step.dart';
import 'package:client/features/user_signup/widgets/allergens_step.dart';
import 'package:client/features/user_signup/widgets/username_step.dart';
import 'package:client/features/home/views/home_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/colorful_text_builder.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../l10n/app_localizations.dart';
import '../viewmodels/account_verification_viewmodel.dart';
import '../viewmodels/allergens_viewmodel.dart';
import '../viewmodels/email_viewmodel.dart';
import '../viewmodels/post_code_viewmodel.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../viewmodels/username_viewmodel.dart';
import '../widgets/email_step.dart';
import '../widgets/post_code_step.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  ListView element = ListView();

  @override
  Widget build(BuildContext context) {
    final SignupViewModel viewModel = Provider.of<SignupViewModel>(context);
    Widget content;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.signupFinalized) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                  create: (context) => HomePageViewModel(), child: const HomePage(),),),
        );
        return;
      }
      if (viewModel.isStepStateError) {
        final String? message = viewModel.currentStepErrorMessage;
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
          value: viewModel.currentViewModel as UsernameViewModel,
          child: const UsernameStep(),
        );
        break;
      case 1:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel as EmailViewModel,
          child: const EmailStep(),
        );
        break;
      case 2:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel as PostCodeViewModel,
          child: const PostCodeStep(),
        );
        break;
      case 3:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel as AllergensViewModel,
          child: const AllergensStep(),
        );
        break;
      case 4:
        content = ChangeNotifierProvider.value(
          value: viewModel.currentViewModel as AccountVerificationViewModel,
          child: const AccountVerificationStep(),
        );
        break;
      default:
        content =
            Center(child: Text(AppLocalizations.of(context)!.no_more_steps));
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
                ColorfulTextBuilder(
                        AppLocalizations.of(context)!.sign_up_title, 50, true,)
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
                          child: const HomePage(),),),);
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
                  child: Text(AppLocalizations.of(context)!.back),
                ),
                ElevatedButton(
                  onPressed: viewModel.nextStep,
                  child: Text(AppLocalizations.of(context)!.next),
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
