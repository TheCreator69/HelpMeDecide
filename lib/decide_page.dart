import 'dart:math';

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

  List<int> previousDecisions = [];

  void makeDecision() {
    setState(() {
      decision = widget.decisionMaker.getDecisionAt(getRandomDecisionIndex());
    });
  }

  int getRandomDecisionIndex() {
    int maxDecisions = widget.decisionMaker.getAmountOfDecisions();

    int index = -1;
    while (index == -1 || previousDecisions.contains(index)) {
      index = Random().nextInt(maxDecisions);
    }

    if (previousDecisions.length == maxDecisions - 1) {
      previousDecisions.clear();
    }
    previousDecisions.add(index);

    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.decisionMaker.title)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Container(
                margin: const EdgeInsets.all(16.0),
                child: Text(
                  decision,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                )),
            Expanded(
              child: Container(),
            ),
            ElevatedButton(
                onPressed: () {
                  makeDecision();
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero))),
                child: const Text("Decide!"))
          ],
        ));
  }
}
