import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpmedecide/model/types.dart';
import 'package:helpmedecide/view/navigation_page.dart';

import 'model/controllers.dart';

void main() async {
  await GetStorage.init();

  Get.put(StorageController());
  final storageController = Get.find<StorageController>();

  Get.put(DecisionMakersController());
  final decisionMakersController = Get.find<DecisionMakersController>();

  List<DecisionMaker> loadedList = storageController.loadDecisionMakers();
  decisionMakersController.setDecisionMakers(loadedList);

  Get.put(LocaleController());
  final localeController = Get.find<LocaleController>();
  localeController.loadLocaleSettings();

  Get.put(ThemeController());
  final themeController = Get.find<ThemeController>();
  themeController.loadThemeMode();

  Get.put(DecisionThemeController());
  final decisionThemeController = Get.find<DecisionThemeController>();
  decisionThemeController.loadDecisionThemeInfo();

  runApp(DecisionApp());

  final settingsController = Get.put(SettingsController());
  await settingsController.retrieveAppVersion();
}

class DecisionApp extends StatelessWidget {
  DecisionApp({super.key});

  final storageController = Get.find<StorageController>();
  final themeController = Get.find<ThemeController>();
  final localeController = Get.find<LocaleController>();

  @override
  Widget build(BuildContext context) {
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
      themeMode: themeController.currentThemeMode.value,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeController.currentLocale.value,
      fallbackLocale: const Locale("en", "US"),
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      home: const NavigationPage(),
    );
  }
}
