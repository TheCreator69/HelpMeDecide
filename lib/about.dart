import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("About")),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20.0),
            child: Column(children: const <Widget>[
              Text(
                "Help me Decide",
                style: TextStyle(fontSize: 24.0),
              ),
              Text("Copyright 2023 TheCreator"),
            ])));
  }
}
