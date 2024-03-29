import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/model/types.dart';

class DecisionSession {
  DecisionSession({required this.decisionMakerIndex});

  final decisionMakersController = Get.find<DecisionMakersController>();
  int decisionMakerIndex;

  int decisionIndex = 0;
  List<int> previousDecisions = [];

  DecisionMaker getDecisionMaker() {
    return decisionMakersController.getDecisionMakerAt(decisionMakerIndex);
  }

  void makeDecision() {
    decisionIndex = _getRandomDecisionIndex();
  }

  int _getRandomDecisionIndex() {
    int maxDecisions = getDecisionMaker().getAmountOfDecisions();

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

  String getDecisionText(BuildContext context) {
    return getDecisionMaker().getDecisionAt(decisionIndex);
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
