import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class DecisionMakerListModel extends ChangeNotifier {
  List<DecisionMaker> _decisionMakers = [];

  void setDecisionMakers(List<DecisionMaker> decisionMakers) {
    _decisionMakers = decisionMakers;
    notifyListeners();
  }

  void addDecisionMaker(DecisionMaker maker) {
    _decisionMakers.add(maker);
    notifyListeners();
  }

  void addDecisionMakerByInfo(String title, List<String> decisions) {
    DecisionMaker newDecisionMaker = createDecisionMaker(title, decisions);
    _decisionMakers.add(newDecisionMaker);
    notifyListeners();
  }

  DecisionMaker createDecisionMaker(String title, List<String> decisions) {
    List<int> takenIDs = _getTakenIDs();

    int id = -1;
    while (id == -1 || takenIDs.contains(id)) {
      id = Random().nextInt(1000000);
    }

    DecisionMaker decisionMaker = DecisionMaker(id: id, title: title);
    decisionMaker._decisions = decisions;
    return decisionMaker;
  }

  void changeDecisionMaker(int id, String title, List<String> decisions) {
    List<int> takenIDs = _getTakenIDs();
    if (!takenIDs.contains(id)) {
      return;
    }

    DecisionMaker maker = DecisionMaker(id: id, title: title);
    maker._decisions = decisions;
    int index = _decisionMakers.indexWhere((element) => element.id == id);
    _decisionMakers[index] = maker;
    notifyListeners();
  }

  void removeDecisionMaker(DecisionMaker decisionMaker) {
    _decisionMakers.remove(decisionMaker);
    notifyListeners();
  }

  DecisionMaker getDecisionMakerAt(int index) {
    return _decisionMakers[index];
  }

  int getAmountOfDecisionMakers() {
    return _decisionMakers.length;
  }

  List<int> _getTakenIDs() {
    return _decisionMakers.map((maker) => maker.id).toList();
  }
}

const idKey = "ids";

Future<List<DecisionMaker>> loadDecisionMakers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? dIDs = prefs.getStringList(idKey);
  if (dIDs?.isEmpty ?? true) {
    return [];
  }

  List<DecisionMaker> decisionMakers = [];

  for (String id in dIDs!) {
    String? title = prefs.getString("d_${id}_title");
    List<String>? decisions = prefs.getStringList("d_${id}_decisions");

    DecisionMaker newDecisionMaker =
        DecisionMaker(id: int.parse(id), title: title!);
    newDecisionMaker._decisions = decisions!;

    decisionMakers.add(newDecisionMaker);
  }

  return decisionMakers;
}

Future<void> saveDecisionMaker(DecisionMaker decisionMaker) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await _saveDecisionMakerID(decisionMaker, prefs);
  await _saveDecisionMakerInfo(decisionMaker, prefs);
}

Future<void> _saveDecisionMakerID(
    DecisionMaker decisionMaker, SharedPreferences prefs) async {
  String decisionMakerID = decisionMaker.id.toString();

  List<String>? decisionMakerIDs = prefs.getStringList(idKey) ?? [];
  if (!decisionMakerIDs.contains(decisionMakerID)) {
    decisionMakerIDs.add(decisionMakerID);
  }

  await prefs.setStringList(idKey, decisionMakerIDs);
}

Future<void> _saveDecisionMakerInfo(
    DecisionMaker decisionMaker, SharedPreferences prefs) async {
  await prefs.setString("d_${decisionMaker.id}_title", decisionMaker.title);
  await prefs.setStringList(
      "d_${decisionMaker.id}_decisions", decisionMaker._decisions);
}

Future<void> saveRemovalOfDecisionMaker(DecisionMaker decisionMaker) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? decisionMakerIDs = prefs.getStringList(idKey) ?? [];
  decisionMakerIDs.remove(decisionMaker.id.toString());
  await prefs.setStringList(idKey, decisionMakerIDs);

  prefs.remove("d_${decisionMaker.id}_title");
  prefs.remove("d_${decisionMaker.id}_decisions");
}
