import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../themes/app_theme.dart';
import '../widgets/simple_button.dart';

class Success extends StatefulWidget {
  final Map<String, int> score;
  final Map<String, int> total;

  const Success({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  showScore() {
    if (widget.score["score"]! < 5) {
      return const Text(
        "C’est un bon début ! Avec un peu plus de pratique, vous allez sûrement améliorer votre score.",
        textAlign: TextAlign.center,
      );
    } else if (widget.score["score"]! > 5 && widget.score["score"]! < 10) {
      return const Text(
        "Bravo pour votre effort ! Avec quelques révisions supplémentaires, vous vous rapprocherez de votre objectif.",
        textAlign: TextAlign.center,
      );
    } else if (widget.score["score"]! == 10 || widget.score["score"]! < 15) {
      return const Text(
        "Excellent score ! Vous êtes en train de maîtriser le sujet. Continuez de vous exercer pour vous perfectionner encore plus.",
        textAlign: TextAlign.center,
      );
    } else if (widget.score["score"]! > 15) {
      return (
        const Text(
          "Félicitations ! Vous avez fait un travail remarquable. Avec ce niveau de compétence, vous êtes prêt(e) pour de nouveaux défis.",
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Votre Score".toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Lottie.asset('assets/lotties/congratulations.json'),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${widget.score["score"]}",
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "/${widget.score["total"]}",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                showScore(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                SimpleButton(
                  color: AppTheme.primaryColor,
                  textColor: Colors.white,
                  text: "Reprendre".toUpperCase(),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
