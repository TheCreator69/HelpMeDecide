import 'package:flutter/material.dart';

class DecisionMaker {
  DecisionMaker({required this.id, required this.title});

  late int id;
  String title;
  List<String> _decisions = [];

  void setDecisions(List<String> decisions) {
    _decisions = decisions;
  }

  List<String> getDecisions() {
    return _decisions;
  }

  String getDecisionAt(int index) {
    return _decisions[index];
  }

  void removeDecisionByIndex(int index) {
    if (index >= _decisions.length) {
      return;
    }
    _decisions.removeAt(index);
  }

  int getAmountOfDecisions() {
    return _decisions.length;
  }
}

class DecisionThemeData {
  DecisionThemeData(
      {required this.id,
      required this.name,
      required this.description,
      this.preview});

  final int id;
  final String name;
  final String description;
  Image? preview;
}
