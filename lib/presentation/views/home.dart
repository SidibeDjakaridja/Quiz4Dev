import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prep_for_dev/core/utils/app_helpers.dart';
import 'package:prep_for_dev/domain/entities/technology.dart';
import 'package:prep_for_dev/presentation/viewmodels/home.dart';
import 'package:prep_for_dev/presentation/widgets/technology.dart';
import 'package:prep_for_dev/themes/app_theme.dart';

import '../viewmodels/game.dart';
import 'loading.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Technology> filteredTechnologies = [];
  TextEditingController searchController = TextEditingController();

  void filterTechnologies(String query, List<Technology> technologies) {
    setState(() {
      filteredTechnologies = technologies
          .where((technology) =>
              technology.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppTheme.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
          body: Consumer(
            builder: (context, ref, child) {
              final homeViewModel = ref.watch(homeViewModelProvider);
              final gameViewModel = ref.watch(gameViewModelProvider);

              return homeViewModel.isLoading
                  ? const LoadingPage(
                      text:
                          "Chargement du questionnaire\nadapté à votre profil...",
                    )
                  : SizedBox(
                      width: size.width,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          const ListTile(
                            title: Text(
                              "Hello ! 👋🏽",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            subtitle: Text("Bienvenue sur Quiz4Dev"),
                            contentPadding: EdgeInsets.zero,
                          ),
                          AppHelpers.getSpacerHeight(1),
                          const Text(
                            "Quelle technologie souhaitez-vous \napprendre aujourd'hui ?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppHelpers.getSpacerHeight(2),
                          Card(
                            margin: EdgeInsets.zero,
                            elevation: 0.0,
                            color: Colors.transparent,
                            child: Container(
                              width: size.width,
                              alignment: Alignment.center,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                controller: searchController,
                                onChanged: (value) => filterTechnologies(
                                    value, homeViewModel.technologies),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.only(top: 9, left: 10),
                                  hintText: "Rechercher ici...",
                                  hintStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Icon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      size: 20,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: GestureDetector(
                                      onTap: () {
                                        String text = searchController.text;
                                        if (text.isNotEmpty) {
                                          if (homeViewModel.technologies.any(
                                            (Technology technology) =>
                                                technology.title == text,
                                          )) {
                                            homeViewModel.changeQuestion(text);
                                            TechnologyCard.showModalBottomSheet(
                                              context,
                                              homeViewModel,
                                              gameViewModel,
                                            );
                                          } else {
                                            AppHelpers.showSnackBar(
                                              context,
                                              "Veuillez choisir une technologie",
                                            );
                                          }
                                        } else {
                                          AppHelpers.showSnackBar(
                                            context,
                                            "Ecrivez quelque chose",
                                          );
                                        }
                                      },
                                      child: const CircleAvatar(
                                        backgroundColor:
                                            AppTheme.secondaryColor,
                                        child: Icon(
                                          FontAwesomeIcons.paperPlane,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AppHelpers.getSpacerHeight(5),
                          filteredTechnologies.isNotEmpty
                              ? GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: filteredTechnologies.length,
                                  padding: const EdgeInsets.only(bottom: 20),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 0.9,
                                  ),
                                  itemBuilder: (ctx, index) {
                                    return TechnologyCard(
                                      parentContext: context,
                                      technology:
                                          filteredTechnologies[index],
                                    );
                                  },
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Mes Technologies",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              "/alltechnologies",
                                            );
                                          },
                                          child: const Text(
                                            "Voir plus",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    AppHelpers.getSpacerHeight(2),
                                    GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          homeViewModel.technologies.length,
                                      padding: const EdgeInsets.only(bottom: 20),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: 0.9,
                                      ),
                                      itemBuilder: (ctx, index) {
                                        return TechnologyCard(
                                          parentContext: context,
                                          technology: homeViewModel
                                              .technologies[index],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}