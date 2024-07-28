import 'package:flutter/material.dart';
import 'package:prep_for_dev/core/utils/app_helpers.dart';
import 'package:prep_for_dev/themes/app_theme.dart';

import '../../../core/utils/preferences.dart';
import '../../widgets/simple_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor.withOpacity(0.3), Colors.white],
            stops: const [0.0, 0.4],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Quiz4Dev 〽️",
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
              AppHelpers.getSpacerHeight(1),
              Image.asset("assets/images/developpeur.png"),
              const Text(
                "Tremplin pour apprendre\nen s'amusant",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              AppHelpers.getSpacerHeight(1),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Apprenez les concepts les plus basiques\ndu développement avec nos questions et réponses soigneusement sélectionnées\npar Gemini AI.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              AppHelpers.getSpacerHeight(2),
              SimpleButton(
                color: AppTheme.primaryColor,
                textColor: Colors.white,
                text: "Commencer Maintenant",
                onPressed: () {
                  SharedPreferencesHelper.setIntValue("is_not_first", 1);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
