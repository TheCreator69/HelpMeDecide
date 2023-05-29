import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'model/controllers.dart';

import 'view/home_page.dart';

void main() async {
  await GetStorage.init();
  runApp(DecisionApp());
}

class DecisionApp extends StatelessWidget {
  DecisionApp({super.key});

  final themeController = Get.put(ThemeController());

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
      themeMode: themeController.loadThemeMode(),
      home: const HomePage(),
    );
  }
}
