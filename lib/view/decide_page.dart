import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/view/edit_page.dart';

import '../model/decision_maker.dart';

class DecidePage extends StatefulWidget {
  const DecidePage({super.key, required this.decisionMaker});

  final DecisionMaker decisionMaker;

  @override
  State<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends State<DecidePage> {
  String decision = "";
  String decisionAction = "";
  bool decisionMade = false;

  List<int> previousDecisions = [];

  void makeDecision() {
    setState(() {
      decision = widget.decisionMaker.getDecisionAt(getRandomDecisionIndex());
      decisionMade = true;
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
    if (decisionMade) {
      decisionAction =
          AppLocalizations.of(context)!.decidePageFurtherDecisionActions;
    } else {
      decision = AppLocalizations.of(context)!.decidePageNoDecisionYet;
      decisionAction =
          AppLocalizations.of(context)!.decidePageFirstDecisionAction;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.decisionMaker.title),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(EditPage(
                      decisionMaker: widget.decisionMaker,
                      isCreatingDecisionMaker: false));
                },
                icon: const Icon(Icons.edit))
          ],
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
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(),
            ),
            SizedBox(
                height: 100.0,
                child: ElevatedButton(
                    onPressed: () {
                      makeDecision();
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(4.0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero))),
                    child: Text(decisionAction,
                        style: const TextStyle(fontSize: 24)))),
          ],
        ));
  }
}
