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
            child: Column(children: <Widget>[
              Expanded(child: Container()),
              const Text(
                "Help me Decide v1.0",
                style: TextStyle(fontSize: 24.0),
              ),
              const Text("Copyright 2023 TheCreator"),
              Expanded(child: Container()),
            ])));
  }
}
