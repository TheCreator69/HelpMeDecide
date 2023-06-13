import 'package:flutter/material.dart';

import 'decision_maker.dart';

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
