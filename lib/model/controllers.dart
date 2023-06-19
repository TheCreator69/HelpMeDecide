import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'decision_maker.dart';

class DecisionAppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DecisionMakersController());
    Get.lazyPut(() => StorageController());
  }
}

class DecisionMakersController extends GetxController {
  RxList<dynamic> decisionMakers = [].obs;

  void setDecisionMakers(List<DecisionMaker> newDecisionMakers) {
    decisionMakers = RxList<dynamic>(newDecisionMakers);
  }

  void addDecisionMaker(DecisionMaker maker) {
    decisionMakers.add(maker);
  }

  void addDecisionMakerByInfo(String title, List<String> decisions) {
    DecisionMaker newDecisionMaker = createDecisionMaker(title, decisions);
    decisionMakers.add(newDecisionMaker);
  }

  DecisionMaker createDecisionMaker(String title, List<String> decisions) {
    List<dynamic> takenIDs = _getTakenIDs();

    int id = -1;
    while (id == -1 || takenIDs.contains(id)) {
      id = Random().nextInt(1000000);
    }

    DecisionMaker decisionMaker = DecisionMaker(id: id, title: title);
    decisionMaker.setDecisions(decisions);
    return decisionMaker;
  }

  void changeDecisionMaker(int id, String title, List<String> decisions) {
    List<dynamic> takenIDs = _getTakenIDs();
    if (!takenIDs.contains(id)) {
      return;
    }

    DecisionMaker maker = DecisionMaker(id: id, title: title);
    maker.setDecisions(decisions);
    int index = decisionMakers.indexWhere((element) => element.id == id);
    decisionMakers[index] = maker;
  }

  void removeDecisionMaker(DecisionMaker decisionMaker) {
    decisionMakers.remove(decisionMaker);
  }

  DecisionMaker getDecisionMakerAt(int index) {
    return decisionMakers[index];
  }

  int getAmountOfDecisionMakers() {
    return decisionMakers.length;
  }

  List<dynamic> _getTakenIDs() {
    return decisionMakers.map((maker) => maker.id).toList();
  }
}

// Move loading and storing of any and all data from the other controllers to this controller
class StorageController extends GetxController {
  final _box = GetStorage();

  static const idKey = "ids";

  List<DecisionMaker> loadDecisionMakers() {
    List<dynamic> dIDs = _box.read(idKey) ?? [];

    List<DecisionMaker> decisionMakers = [];

    for (String id in dIDs) {
      String? title = _box.read("d_${id}_title");
      List<dynamic>? decisions = _box.read("d_${id}_decisions");

      DecisionMaker newDecisionMaker =
          DecisionMaker(id: int.parse(id), title: title!);
      newDecisionMaker
          .setDecisions(decisions!.map((e) => e.toString()).toList());

      decisionMakers.add(newDecisionMaker);
    }

    return decisionMakers;
  }

  void saveDecisionMaker(DecisionMaker decisionMaker) {
    _saveDecisionMakerID(decisionMaker);
    _saveDecisionMakerInfo(decisionMaker);
  }

  void _saveDecisionMakerID(DecisionMaker decisionMaker) async {
    String decisionMakerID = decisionMaker.id.toString();

    List<dynamic> decisionMakerIDs = _box.read(idKey) ?? [];
    if (!decisionMakerIDs.contains(decisionMakerID)) {
      decisionMakerIDs.add(decisionMakerID);
    }
    await _box.write(idKey, decisionMakerIDs);
  }

  void _saveDecisionMakerInfo(DecisionMaker decisionMaker) async {
    await _box.write("d_${decisionMaker.id}_title", decisionMaker.title);
    await _box.write(
        "d_${decisionMaker.id}_decisions", decisionMaker.getDecisions());
  }

  void saveRemovalOfDecisionMaker(DecisionMaker decisionMaker) async {
    List<dynamic>? decisionMakerIDs = _box.read(idKey) ?? [];

    decisionMakerIDs.remove(decisionMaker.id.toString());

    await _box.write(idKey, decisionMakerIDs);

    await _box.remove("d_${decisionMaker.id}_title");
    await _box.remove("d_${decisionMaker.id}_decisions");
  }
}

// Combine ThemeController and LocaleController to SettingsController
class ThemeController extends GetxController {
  final GetStorage _box = GetStorage();

  final String _themeKey = "theme";
  Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  ThemeMode loadThemeMode() {
    final String themeValue = _box.read(_themeKey) ?? "system";
    switch (themeValue) {
      case "system":
        currentThemeMode.value = ThemeMode.system;
        break;
      case "light":
        currentThemeMode.value = ThemeMode.light;
        break;
      case "dark":
        currentThemeMode.value = ThemeMode.dark;
        break;
      default:
        currentThemeMode.value = ThemeMode.system;
        break;
    }
    return currentThemeMode.value;
  }

  void saveThemeMode(ThemeMode themeMode) {
    String themeValue = "";
    switch (themeMode) {
      case ThemeMode.system:
        themeValue = "system";
        break;
      case ThemeMode.light:
        themeValue = "light";
        break;
      case ThemeMode.dark:
        themeValue = "dark";
        break;
      default:
        themeValue = "system";
        break;
    }
    _box.write(_themeKey, themeValue);
  }

  void applyThemeMode(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
    currentThemeMode.value = themeMode;
  }
}

class LocaleController extends GetxController {
  final GetStorage _box = GetStorage();
  final String _localeKey = "locale";
  final String _localeModeKey = "localeMode";

  Rx<Locale> currentLocale = (Get.deviceLocale ?? Get.fallbackLocale!).obs;
  Rx<bool> usingSystemLocale = true.obs;

  void loadLocaleSettings() {
    final bool isUsingSystemLocale = _box.read(_localeModeKey) ?? true;
    usingSystemLocale.value = isUsingSystemLocale;

    List<String> loadedLocaleInfo =
        (_box.read(_localeKey) ?? "en-US").toString().split("-");
    currentLocale.value = Locale(loadedLocaleInfo[0],
        loadedLocaleInfo.length > 1 ? loadedLocaleInfo[1] : null);
  }

  void saveLocale(Locale locale) {
    String localeValue = locale.toLanguageTag();
    _box.write(_localeKey, localeValue);
  }

  void applyLocale(Locale locale) {
    Get.updateLocale(locale);
    currentLocale.value = locale;
  }

  void saveIsUsingSystemLocale(bool isUsingSystemLocale) {
    _box.write(_localeModeKey, isUsingSystemLocale);
  }

  void applyIsUsingSystemLocale(bool isUsingSystemLocale) {
    usingSystemLocale.value = isUsingSystemLocale;
    if (isUsingSystemLocale) {
      saveLocale(Get.deviceLocale!);
      applyLocale(Get.deviceLocale!);
    } else {
      saveLocale(currentLocale.value);
      applyLocale(currentLocale.value);
    }
  }

  String getLocaleDisplayText(Locale locale, BuildContext context) {
    final Map<Locale, String> localeToDisplayText = {
      const Locale("en", "US"):
          AppLocalizations.of(context)!.settingsPageLanguageEnglish,
      const Locale("de"):
          AppLocalizations.of(context)!.settingsPageLanguageGerman,
    };
    return localeToDisplayText[locale] ??
        AppLocalizations.of(context)!.settingsPageLanguageEnglish;
  }
}

class SettingsController extends GetxController {
  late final String appVersion;

  Future<void> retrieveAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }
}
