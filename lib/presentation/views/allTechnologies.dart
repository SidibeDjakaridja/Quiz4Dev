import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prep_for_dev/presentation/views/loading.dart';

import '../viewmodels/game.dart';
import '../viewmodels/home.dart';
import '../widgets/technology.dart';

class AllTechnologies extends StatefulWidget {
  const AllTechnologies({super.key});

  @override
  State<AllTechnologies> createState() => _AllTechnologiesState();
}

class _AllTechnologiesState extends State<AllTechnologies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text("Toutes les technologies"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final homeViewModel = ref.watch(homeViewModelProvider);
          final gameViewModel = ref.watch(gameViewModelProvider);
          return homeViewModel.isLoading
              ? const LoadingPage(
                  text: "Chargement du questionnaire\nadapté à votre profil...",
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: homeViewModel.technologies.length,
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
                          technology: homeViewModel.technologies[index],
                        );
                      },
                    ),
                  ],
                );
        },
      ),
    );
  }
}
