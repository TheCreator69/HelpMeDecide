import 'package:flutter/material.dart';

import 'decision_makers.dart';

class DecidePage extends StatefulWidget {
  const DecidePage({super.key, required this.decisionMaker});

  final DecisionMaker decisionMaker;

  @override
  State<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends State<DecidePage> {
  String decision = "Decision will appear here...";

  void makeDecision() {
    setState(() {
      decision = widget.decisionMaker.getRandomDecision();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Decide on Something")),
      body: Center(
          child: Column(
        children: <Widget>[
          Text(decision),
          ElevatedButton(
              onPressed: () {
                makeDecision();
              },
              child: const Text("Decide!"))
        ],
      )),
    );
  }
}
