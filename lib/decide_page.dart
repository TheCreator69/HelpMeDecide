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
  String decisionAction = "Decide!";

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
        appBar: AppBar(
          title: Text(widget.decisionMaker.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Text(
              decision,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(),
            ),
            ElevatedButton(
                onPressed: () {
                  makeDecision();
                  decisionAction = "Decide again!";
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(4.0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero))),
                child: Text(decisionAction)),
          ],
        ));
  }
}
