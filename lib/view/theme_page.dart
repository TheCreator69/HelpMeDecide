import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/view/settings_page.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.themePageTitle),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => SettingsPage());
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: Get.find<DecisionThemeController>().availableThemes.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return ThemeCard(index: index);
          },
        ));
  }
}

class ThemeCard extends StatelessWidget {
  ThemeCard({super.key, required this.index});

  final int index;
  final decisionThemeController = Get.find<DecisionThemeController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      clipBehavior: Clip.hardEdge,
      child: Column(children: [
        Visibility(
            visible:
                decisionThemeController.availableThemes[index].preview != null,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                1, 0, 0, 0, 10, // Red channel adjustment
                0, 1, 0, 0, 10, // Green channel adjustment
                0, 0, 1, 0, 10, // Blue channel adjustment
                0, 0, 0, 1, 0, // Alpha channel adjustment
              ]),
              child: decisionThemeController.availableThemes[index].preview,
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        decisionThemeController.availableThemes[index].name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        decisionThemeController
                            .availableThemes[index].description,
                        softWrap: true,
                      ),
                    ]),
              ),
              Expanded(
                child: Obx(
                  () => Switch(
                    value:
                        decisionThemeController.currentDecisionThemeID.value ==
                            index,
                    onChanged: (value) {
                      decisionThemeController.applyDecisionTheme(index);
                      decisionThemeController.saveDecisionTheme(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
