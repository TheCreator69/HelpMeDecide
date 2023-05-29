import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/controllers.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          children: [
            const Text("Change Theme", style: TextStyle(fontSize: 14)),
            Obx(
              () => RadioListTile<ThemeMode>(
                  title: const Text("Use System Settings"),
                  value: ThemeMode.system,
                  groupValue: themeController.currentThemeMode.value,
                  onChanged: (ThemeMode? value) {
                    themeController.applyThemeMode(value ?? ThemeMode.system);
                    themeController.saveThemeMode(value ?? ThemeMode.system);
                  }),
            ),
            Obx(
              () => RadioListTile(
                  title: const Text("Light Mode"),
                  value: ThemeMode.light,
                  groupValue: themeController.currentThemeMode.value,
                  onChanged: (ThemeMode? value) {
                    themeController.applyThemeMode(value ?? ThemeMode.system);
                    themeController.saveThemeMode(value ?? ThemeMode.system);
                  }),
            ),
            Obx(
              () => RadioListTile(
                  title: const Text("Dark Mode"),
                  value: ThemeMode.dark,
                  groupValue: themeController.currentThemeMode.value,
                  onChanged: (ThemeMode? value) {
                    themeController.applyThemeMode(value ?? ThemeMode.system);
                    themeController.saveThemeMode(value ?? ThemeMode.system);
                  }),
            ),
          ],
        ));
  }
}
