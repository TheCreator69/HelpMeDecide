import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpmedecide/view/navigation_page.dart';

import 'model/controllers.dart';

void main() async {
  await GetStorage.init();

  runApp(DecisionApp());

  final settingsController = Get.put(SettingsController());
  await settingsController.retrieveAppVersion();
}

class DecisionApp extends StatelessWidget {
  DecisionApp({super.key});

  final storageController = Get.put(StorageController());
  final themeController = Get.put(ThemeController());
  final localeController = Get.put(LocaleController());

  @override
  Widget build(BuildContext context) {
    localeController.loadLocaleSettings();

    return GetMaterialApp(
      title: "Help me Decide",
      debugShowCheckedModeBanner: false,
      initialBinding: DecisionAppBindings(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(),
        brightness: Brightness.dark,
      ),
      themeMode: themeController.loadThemeMode(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeController.currentLocale.value,
      fallbackLocale: const Locale("en", "US"),
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      home: const NavigationPage(),
    );
  }
}
