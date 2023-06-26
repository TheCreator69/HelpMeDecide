import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:helpmedecide/model/types.dart';
import 'package:helpmedecide/view/decisions/decide_page_classic.dart';
import 'package:helpmedecide/view/decisions/decide_page_wheel.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DecisionAppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DecisionMakersController());
    Get.lazyPut(() => StorageController());
    Get.lazyPut(() => ThemeController());
    Get.lazyPut(() => DecisionThemeController());
    Get.lazyPut(() => LocaleController());
    Get.lazyPut(() => SettingsController());
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

  dynamic loadValueByKey(String key, dynamic fallback) {
    return _box.read(key) ?? fallback;
  }

  void saveKeyValuePair(String key, dynamic value) async {
    await _box.write(key, value);
  }
}

class ThemeController extends GetxController {
  final String _themeKey = "theme";

  Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  void loadThemeMode() {
    final String themeValue =
        Get.find<StorageController>().loadValueByKey(_themeKey, "system");
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

    Get.find<StorageController>().saveKeyValuePair(_themeKey, themeValue);
  }

  void applyThemeMode(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
    currentThemeMode.value = themeMode;
  }
}

class DecisionThemeController extends GetxController {
  final String _decisionThemeKey = "decisionTheme";

  Rx<int> currentDecisionThemeID = 0.obs;

  final List<DecisionThemeData> availableThemes = [];

  void populateAvailableThemes(BuildContext context) {
    availableThemes.clear();

    availableThemes.add(
      DecisionThemeData(
          id: 0,
          name: AppLocalizations.of(context)!.themeClassicName,
          description: AppLocalizations.of(context)!.themeClassicDescription,
          preview: Image.asset("assets/classic_thumb.png")),
    );
    availableThemes.add(DecisionThemeData(
        id: 1,
        name: AppLocalizations.of(context)!.themeWheelName,
        description: AppLocalizations.of(context)!.themeWheelDescription));
  }

  DecisionThemeData getCurrentTheme() {
    return availableThemes[currentDecisionThemeID.value];
  }

  Widget getDecisionScreen(int index) {
    switch (currentDecisionThemeID.value) {
      case 0:
        return DecidePageClassic(decisionMakerIndex: index);
      default:
        return DecidePageWheel(decisionMakerIndex: index);
    }
  }

  void loadDecisionThemeInfo() {
    currentDecisionThemeID.value =
        Get.find<StorageController>().loadValueByKey(_decisionThemeKey, 0);
  }

  void applyDecisionTheme(int newID) {
    if (newID >= availableThemes.length) return;
    currentDecisionThemeID.value = newID;
  }

  void saveDecisionTheme(int newID) {
    if (newID >= availableThemes.length) return;
    Get.find<StorageController>().saveKeyValuePair(_decisionThemeKey, newID);
  }
}

class LocaleController extends GetxController {
  final String _localeKey = "locale";
  final String _localeModeKey = "localeMode";

  Rx<Locale> currentLocale = (Get.deviceLocale ?? Get.fallbackLocale!).obs;
  Rx<bool> usingSystemLocale = true.obs;

  void loadLocaleSettings() {
    final bool isUsingSystemLocale =
        Get.find<StorageController>().loadValueByKey(_localeModeKey, true);
    usingSystemLocale.value = isUsingSystemLocale;

    List<String> loadedLocaleInfo = Get.find<StorageController>()
        .loadValueByKey(_localeKey, "en-US")
        .toString()
        .split("-");
    currentLocale.value = Locale(loadedLocaleInfo[0],
        loadedLocaleInfo.length > 1 ? loadedLocaleInfo[1] : null);
  }

  void saveLocale(Locale locale) {
    String localeValue = locale.toLanguageTag();
    Get.find<StorageController>().saveKeyValuePair(_localeKey, localeValue);
  }

  void applyLocale(Locale locale) {
    Get.updateLocale(locale);
    currentLocale.value = locale;
  }

  void saveIsUsingSystemLocale(bool isUsingSystemLocale) {
    Get.find<StorageController>()
        .saveKeyValuePair(_localeModeKey, isUsingSystemLocale);
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
