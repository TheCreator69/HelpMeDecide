import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';

import 'decision_maker.dart';

class DecisionSession {
  DecisionSession({required this.decisionMakerIndex});

  final decisionMakersController = Get.find<DecisionMakersController>();
  int decisionMakerIndex;

  int decisionIndex = 0;
  bool decisionMade = false;

  List<int> previousDecisions = [];

  DecisionMaker getDecisionMaker() {
    return decisionMakersController.getDecisionMakerAt(decisionMakerIndex);
  }

  void makeDecision() {
    decisionMade = true;
    decisionIndex = _getRandomDecisionIndex();
  }

  int _getRandomDecisionIndex() {
    int maxDecisions = getDecisionMaker().getAmountOfDecisions();

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

  String getDecisionText(BuildContext context) {
    if (decisionMade) {
      return getDecisionMaker().getDecisionAt(decisionIndex);
    }
    return AppLocalizations.of(context)!.decidePageNoDecisionYet;
  }

  String getDecisionActionText(BuildContext context) {
    if (decisionMade) {
      return AppLocalizations.of(context)!.decidePageFurtherDecisionActions;
    } else {
      return AppLocalizations.of(context)!.decidePageFirstDecisionAction;
    }
  }
}