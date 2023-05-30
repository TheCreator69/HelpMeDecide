import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../model/controllers.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsPageAboutTitle),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          children: [
            Text(AppLocalizations.of(context)!.settingsPageThemeSectionTitle,
                style: const TextStyle(fontSize: 14)),
            Obx(
              () => RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!
                      .settingsPageThemeOptionSystem),
                  value: ThemeMode.system,
                  groupValue: themeController.currentThemeMode.value,
                  onChanged: (ThemeMode? value) {
                    themeController.applyThemeMode(value ?? ThemeMode.system);
                    themeController.saveThemeMode(value ?? ThemeMode.system);
                  }),
            ),
            Obx(
              () => RadioListTile(
                  title: Text(AppLocalizations.of(context)!
                      .settingsPageThemeOptionLight),
                  value: ThemeMode.light,
                  groupValue: themeController.currentThemeMode.value,
                  onChanged: (ThemeMode? value) {
                    themeController.applyThemeMode(value ?? ThemeMode.system);
                    themeController.saveThemeMode(value ?? ThemeMode.system);
                  }),
            ),
            Obx(
              () => RadioListTile(
                  title: Text(AppLocalizations.of(context)!
                      .settingsPageThemeOptionDark),
                  value: ThemeMode.dark,
                  groupValue: themeController.currentThemeMode.value,
                  onChanged: (ThemeMode? value) {
                    themeController.applyThemeMode(value ?? ThemeMode.system);
                    themeController.saveThemeMode(value ?? ThemeMode.system);
                  }),
            ),
            Card(
                elevation: 2.0,
                child: ListTile(
                  title: Text(
                      AppLocalizations.of(context)!.settingsPageAboutTitle),
                  onTap: () => Get.defaultDialog(
                      radius: 10.0,
                      contentPadding: const EdgeInsets.all(20.0),
                      title:
                          AppLocalizations.of(context)!.settingsPageAboutTitle,
                      middleText: AppLocalizations.of(context)!
                          .settingsPageAboutContent,
                      textConfirm: AppLocalizations.of(context)!
                          .settingsPageAboutConfirm,
                      confirm: OutlinedButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.check),
                          label: Text(AppLocalizations.of(context)!
                              .settingsPageAboutConfirm))),
                )),
          ],
        ));
  }
}
