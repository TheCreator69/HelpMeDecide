import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helpmedecide/model/types.dart';

class DecisionSession {
  DecisionMaker decisionMaker;

  int decisionIndex = 0;
  List<int> previousDecisions = [];

  DecisionSession({required this.decisionMaker});

  void makeDecision() {
    decisionIndex = _getRandomDecisionIndex();
  }

  int _getRandomDecisionIndex() {
    int maxDecisions = decisionMaker.getAmountOfDecisions();

    int index = -1;
    do {
      index = Random().nextInt(maxDecisions);
    } while (previousDecisions.contains(index));

    if (previousDecisions.length == maxDecisions - 1) {
      previousDecisions.clear();
    }
    previousDecisions.add(index);

    return index;
  }

  String getDecisionText() {
    return decisionMaker.getDecisionAt(decisionIndex);
  }
}

class EditSession {
  DecisionMaker decisionMaker;

  TextEditingController titleController = TextEditingController();
  List<TextEditingController> decisionControllers = [];

  EditSession({required this.decisionMaker}) {
    titleController.text = decisionMaker.title;

    if (decisionMaker.getDecisions().isEmpty) {
      decisionControllers = [TextEditingController(), TextEditingController()];
    } else {
      for (int i = 0; i < decisionMaker.getDecisions().length; i++) {
        late TextEditingController currentController;
        if (i >= decisionControllers.length) {
          currentController = TextEditingController();
          decisionControllers.add(currentController);
        } else {
          currentController = decisionControllers[i];
        }

        currentController.text = decisionMaker.getDecisionAt(i);
      }
    }
  }

  void addDecisionController() {
    decisionControllers.add(TextEditingController());
  }

  void removeDecisionControllerAt(int index) {
    decisionControllers.removeAt(index);
  }

  void disposeOfControllers() {
    decisionControllers.map((e) => e.dispose());
  }
}
