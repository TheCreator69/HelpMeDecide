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
        appBar: AppBar(title: Text(widget.decisionMaker.title)),
        body: Center(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(decision, style: const TextStyle(fontSize: 28)),
                    ElevatedButton(
                        onPressed: () {
                          makeDecision();
                        },
                        child: const Text("Decide!"))
                  ],
                ))));
  }
}
