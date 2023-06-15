import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/controllers.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final themeController = Get.find<ThemeController>();
  final localeController = Get.find<LocaleController>();

  Future<void> launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsPageTitle),
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
            const Divider(),
            Text(AppLocalizations.of(context)!.settingsPageLanguageSectionTitle,
                style: const TextStyle(fontSize: 14)),
            Obx(
              () => RadioListTile(
                title: Text(AppLocalizations.of(context)!
                    .settingsPageLanguageOptionSystem),
                value: true,
                groupValue: localeController.usingSystemLocale.value,
                onChanged: (value) {
                  localeController.applyIsUsingSystemLocale(value!);
                  localeController.saveIsUsingSystemLocale(value);
                },
              ),
            ),
            Obx(
              () => RadioListTile(
                title: Text(AppLocalizations.of(context)!
                    .settingsPageLanguageOptionCustom),
                value: false,
                groupValue: localeController.usingSystemLocale.value,
                onChanged: (value) {
                  localeController.applyIsUsingSystemLocale(value!);
                  localeController.saveIsUsingSystemLocale(value);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(4)),
              child: Obx(() => DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: localeController.currentLocale.value,
                      onChanged: localeController.usingSystemLocale.value
                          ? null
                          : (Locale? value) {
                              localeController.applyLocale(value!);
                              localeController.saveLocale(value);
                            },
                      items: <Locale>[
                        const Locale("en", "US"),
                        const Locale("de"),
                      ].map<DropdownMenuItem<Locale>>((Locale locale) {
                        return DropdownMenuItem<Locale>(
                            value: locale,
                            child: Text(localeController.getLocaleDisplayText(
                                locale, context)));
                      }).toList(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 24.0),
                      elevation: 2,
                    ),
                  )),
            ),
            const Divider(),
            Card(
                elevation: 2.0,
                child: ListTile(
                  title: Text(
                      AppLocalizations.of(context)!.settingsPageAboutTitle),
                  onTap: () => Get.defaultDialog(
                    radius: 10.0,
                    contentPadding: const EdgeInsets.all(20.0),
                    title: AppLocalizations.of(context)!.settingsPageAboutTitle,
                    middleText: AppLocalizations.of(context)!
                        .settingsPageAboutContent("1.0.2"),
                    textConfirm:
                        AppLocalizations.of(context)!.settingsPageAboutConfirm,
                    confirm: OutlinedButton.icon(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.check),
                        label: Text(AppLocalizations.of(context)!
                            .settingsPageAboutConfirm)),
                    /*
                    actions: [
                      IconButton(
                          onPressed: () => launchURL(Uri.parse(
                              "https://github.com/TheCreator69/HelpMeDecide")),
                          icon: Image.asset(
                            "assets/github.png",
                            width: 48,
                            height: 48,
                            color: Theme.of(context).colorScheme.outline,
                          )),
                      IconButton(
                          onPressed: () => launchURL(
                              Uri.parse("https://discord.gg/PM5BB4JsDE")),
                          icon: Image.asset(
                            "assets/discord.png",
                            width: 48,
                            height: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ))
                    ],
                    */
                  ),
                )),
          ],
        ));
  }
}
