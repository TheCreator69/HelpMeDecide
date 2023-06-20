import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/view/settings_page.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.themePageTitle),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => SettingsPage());
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const <Widget>[
            ThemeCard(),
            ThemeCard(),
            ThemeCard(),
            ThemeCard(),
          ]),
    );
  }
}

class ThemeCard extends StatelessWidget {
  const ThemeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const Placeholder(
          fallbackHeight: 200.0,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Theme title",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("Theme description\nWith multiple lines.")
                  ]),
              Switch(
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
