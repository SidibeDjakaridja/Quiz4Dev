import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prep_for_dev/domain/entities/technology.dart';

import '../../core/utils/app_helpers.dart';
import '../../themes/app_theme.dart';
import '../viewmodels/game.dart';
import '../viewmodels/home.dart';

class TechnologyCard extends ConsumerWidget {
  final Technology technology;
  final BuildContext parentContext;
  const TechnologyCard({
    required this.technology,
    required this.parentContext,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewProvider = ref.watch(homeViewModelProvider);
    final gameViewModel = ref.watch(gameViewModelProvider);

    return GestureDetector(
      onTap: () {
        homeViewProvider.changeQuestion(technology.title);
        showModalBottomSheet(parentContext, homeViewProvider, gameViewModel);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 6,
        margin: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Image.asset(
                  technology.imagePath,
                  height: 50,
                ),
              ),
              AppHelpers.getSpacerHeight(2),
              Text(
                technology.title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showModalBottomSheet(
      BuildContext context, homeViewModel, gameViewModel) {
    showBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Choisissez votre niveau",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      child: const FaIcon(
                        FontAwesomeIcons.xmark,
                        color: Colors.black,
                        size: 18,
                      ),
                      onTap: () => Navigator.pop(ctx),
                    )
                  ],
                ),
                AppHelpers.getSpacerHeight(2),
                getLevelCard(
                  "Dévelopeur Junior",
                  context,
                  ctx,
                  homeViewModel,
                  gameViewModel,
                ),
                getLevelCard(
                  "Développeur de niveau intermédiaire",
                  context,
                  ctx,
                  homeViewModel,
                  gameViewModel,
                ),
                getLevelCard(
                  "Dévelopeur Senior",
                  context,
                  ctx,
                  homeViewModel,
                  gameViewModel,
                )
              ],
            ),
          );
        });
  }

  static getLevelCard(
      String level, context, localContext, homeViewModel, gameViewModel) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(localContext);
        homeViewModel.changeLevel(level);
        homeViewModel.setLoading(true);
        homeViewModel.fetchQuestions().then((value) {
          if (value) {
            gameViewModel.reset();
            Navigator.pushNamed(context, "/game");
          } else {}
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppTheme.primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              level,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const FaIcon(
              FontAwesomeIcons.arrowRight,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
