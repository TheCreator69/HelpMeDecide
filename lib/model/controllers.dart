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
    Get.lazyPut(() => StorageController());
    Get.lazyPut(() => DecisionMakersController());
    Get.lazyPut(() =>
        ThemeController(storageController: Get.find<StorageController>()));
    Get.lazyPut(() => DecisionThemeController(
        storageController: Get.find<StorageController>()));
    Get.lazyPut(() =>
        LocaleController(storageController: Get.find<StorageController>()));
    Get.lazyPut(() => SettingsController());
  }
}

abstract class IDecisionMakersController {
  void setDecisionMakers(List<DecisionMaker> newDecisionMakers);
  void addDecisionMaker(DecisionMaker maker);
  DecisionMaker createDecisionMaker(String title, List<String> decisions);
  void changeDecisionMaker(int id, String title, List<String> decisions);
  void removeDecisionMaker(DecisionMaker decisionMaker);

  RxList<dynamic> get decisionMakers;
  DecisionMaker getDecisionMakerAt(int index);
  int getAmountOfDecisionMakers();
}

class DecisionMakersController extends GetxController
    implements IDecisionMakersController {
  @override
  RxList<dynamic> decisionMakers = [].obs;

  @override
  void setDecisionMakers(List<DecisionMaker> newDecisionMakers) {
    decisionMakers = RxList<dynamic>(newDecisionMakers);
  }

  @override
  void addDecisionMaker(DecisionMaker maker) {
    decisionMakers.add(maker);
  }

  @override
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

  @override
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

  @override
  void removeDecisionMaker(DecisionMaker decisionMaker) {
    decisionMakers.remove(decisionMaker);
  }

  @override
  DecisionMaker getDecisionMakerAt(int index) {
    return decisionMakers[index];
  }

  @override
  int getAmountOfDecisionMakers() {
    return decisionMakers.length;
  }

  List<dynamic> _getTakenIDs() {
    return decisionMakers.map((maker) => maker.id).toList();
  }
}

abstract class IStorageController {
  List<DecisionMaker> loadDecisionMakers();
  void saveDecisionMaker(DecisionMaker decisionMaker);
  Future<void> saveRemovalOfDecisionMaker(DecisionMaker decisionMaker);
  dynamic loadValueByKey(String key, dynamic fallback);
  Future<void> saveKeyValuePair(String key, dynamic value);
}

class StorageController extends GetxController implements IStorageController {
  final _box = GetStorage();

  static const idKey = "ids";

  @override
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

  @override
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

  @override
  Future<void> saveRemovalOfDecisionMaker(DecisionMaker decisionMaker) async {
    List<dynamic>? decisionMakerIDs = _box.read(idKey) ?? [];

    decisionMakerIDs.remove(decisionMaker.id.toString());

    await _box.write(idKey, decisionMakerIDs);

    await _box.remove("d_${decisionMaker.id}_title");
    await _box.remove("d_${decisionMaker.id}_decisions");
  }

  @override
  dynamic loadValueByKey(String key, dynamic fallback) {
    return _box.read(key) ?? fallback;
  }

  @override
  Future<void> saveKeyValuePair(String key, dynamic value) async {
    await _box.write(key, value);
  }
}

abstract class IThemeController {
  Rx<ThemeMode> get currentThemeMode;

  void loadThemeMode();
  void saveThemeMode(ThemeMode themeMode);
  void applyThemeMode(ThemeMode themeMode);
}

class ThemeController extends GetxController implements IThemeController {
  final String _themeKey = "theme";

  final IStorageController storageController;

  @override
  Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  ThemeController({required this.storageController});

  @override
  void loadThemeMode() {
    final String themeValue =
        storageController.loadValueByKey(_themeKey, "system");
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

  @override
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

    storageController.saveKeyValuePair(_themeKey, themeValue);
  }

  @override
  void applyThemeMode(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
    currentThemeMode.value = themeMode;
  }
}

abstract class IDecisionThemeController {
  Rx<int> get currentDecisionThemeID;

  void populateAvailableThemes(BuildContext context);

  DecisionThemeData getCurrentTheme();

  Widget getDecisionScreen(DecisionMaker decisionMaker);

  void loadDecisionThemeInfo();
  void applyDecisionTheme(int newID);
  void saveDecisionTheme(int newID);
}

class DecisionThemeController extends GetxController
    implements IDecisionThemeController {
  final String _decisionThemeKey = "decisionTheme";

  @override
  Rx<int> currentDecisionThemeID = 0.obs;

  final List<DecisionThemeData> availableThemes = [];

  final IStorageController storageController;

  DecisionThemeController({required this.storageController});

  @override
  void populateAvailableThemes(BuildContext context) {
    availableThemes.clear();

    availableThemes.add(
      DecisionThemeData(
          name: AppLocalizations.of(context)!.themeWheelName,
          description: AppLocalizations.of(context)!.themeWheelDescription,
          preview: Image.asset("assets/wheel_thumb.png")),
    );
    availableThemes.add(
      DecisionThemeData(
          name: AppLocalizations.of(context)!.themeClassicName,
          description: AppLocalizations.of(context)!.themeClassicDescription,
          preview: Image.asset("assets/classic_thumb.png")),
    );
  }

  @override
  DecisionThemeData getCurrentTheme() {
    return availableThemes[currentDecisionThemeID.value];
  }

  @override
  Widget getDecisionScreen(DecisionMaker decisionMaker) {
    switch (currentDecisionThemeID.value) {
      case 0:
        return DecidePageWheel(decisionMaker: decisionMaker);
      case 1:
        return DecidePageClassic(decisionMaker: decisionMaker);
      default:
        return DecidePageWheel(decisionMaker: decisionMaker);
    }
  }

  @override
  void loadDecisionThemeInfo() {
    currentDecisionThemeID.value =
        storageController.loadValueByKey(_decisionThemeKey, 0);
  }

  @override
  void applyDecisionTheme(int newID) {
    if (newID >= availableThemes.length) return;
    currentDecisionThemeID.value = newID;
  }

  @override
  void saveDecisionTheme(int newID) {
    if (newID >= availableThemes.length) return;
    storageController.saveKeyValuePair(_decisionThemeKey, newID);
  }
}

abstract class ILocaleController {
  Rx<Locale> get currentLocale;
  Rx<bool> get usingSystemLocale;

  void loadLocaleSettings();

  void saveLocale(Locale locale);
  void applyLocale(Locale locale);

  void saveIsUsingSystemLocale(bool isUsingSystemLocale);
  void applyIsUsingSystemLocale(bool isUsingSystemLocale);

  String getLocaleDisplayText(Locale locale, BuildContext context);
}

class LocaleController extends GetxController implements ILocaleController {
  final String _localeKey = "locale";
  final String _localeModeKey = "localeMode";

  @override
  Rx<Locale> currentLocale = (Get.deviceLocale ?? Get.fallbackLocale!).obs;
  @override
  Rx<bool> usingSystemLocale = true.obs;

  final IStorageController storageController;

  LocaleController({required this.storageController});

  @override
  void loadLocaleSettings() {
    final bool isUsingSystemLocale =
        storageController.loadValueByKey(_localeModeKey, true);
    usingSystemLocale.value = isUsingSystemLocale;

    List<String> loadedLocaleInfo = storageController
        .loadValueByKey(_localeKey, "en-US")
        .toString()
        .split("-");
    currentLocale.value = Locale(loadedLocaleInfo[0],
        loadedLocaleInfo.length > 1 ? loadedLocaleInfo[1] : null);
  }

  @override
  void saveLocale(Locale locale) {
    String localeValue = locale.toLanguageTag();
    storageController.saveKeyValuePair(_localeKey, localeValue);
  }

  @override
  void applyLocale(Locale locale) {
    Get.updateLocale(locale);
    currentLocale.value = locale;
  }

  @override
  void saveIsUsingSystemLocale(bool isUsingSystemLocale) {
    storageController.saveKeyValuePair(_localeModeKey, isUsingSystemLocale);
  }

  @override
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

  @override
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

abstract class ISettingsController {
  Future<void> retrieveAppVersion();
}

class SettingsController extends GetxController implements ISettingsController {
  late final String appVersion;

  @override
  Future<void> retrieveAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }
}
