import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../model/controllers.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final themeController = Get.find<ThemeController>();
  final localeController = Get.find<LocaleController>();

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
            Text(AppLocalizations.of(context)!.settingsPageLanguageSectionTitle,
                style: const TextStyle(fontSize: 14)),
            Obx(
              () => RadioListTile(
                title: Text(AppLocalizations.of(context)!
                    .settingsPageLanguageOptionSystem),
                value: "system",
                groupValue: localeController.localeMode.value,
                onChanged: (value) {
                  localeController.applyIsUsingSystemLocale(true);
                  localeController.saveIsUsingSystemLocale(true);
                },
              ),
            ),
            Obx(
              () => RadioListTile(
                title: Text(AppLocalizations.of(context)!
                    .settingsPageLanguageOptionCustom),
                value: "custom",
                groupValue: localeController.localeMode.value,
                onChanged: (value) {
                  localeController.applyIsUsingSystemLocale(false);
                  localeController.saveIsUsingSystemLocale(false);
                },
              ),
            ),
            Obx(
              () => DropdownButton<Locale>(
                value: localeController.currentLocale.value,
                onChanged: localeController.localeMode.value == "custom"
                    ? (Locale? value) {
                        localeController
                            .applyLocale(value ?? const Locale("en"));
                        localeController
                            .saveLocale(value ?? const Locale("en"));
                      }
                    : null,
                items: <Locale>[
                  const Locale("en", "US"),
                  const Locale("de"),
                ].map<DropdownMenuItem<Locale>>((Locale locale) {
                  return DropdownMenuItem<Locale>(
                      value: locale,
                      child: Text(localeController.getLocaleDisplayText(
                          locale, context)));
                }).toList(),
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0),
                elevation: 2,
              ),
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
