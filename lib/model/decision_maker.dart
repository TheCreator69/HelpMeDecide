import 'dart:math';

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

  String getRandomDecision() {
    if (_decisions.isEmpty) {
      return "";
    }
    return _decisions[Random().nextInt(_decisions.length)];
  }
}
