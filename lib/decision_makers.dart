import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DecisionMaker {
  DecisionMaker({this.id = -1, required this.title}) {
    List<int> takenIDs = decisionMakers.map((maker) => maker.id).toList();

    int potentialID = -1;
    while (potentialID == -1 || takenIDs.contains(potentialID)) {
      potentialID = Random().nextInt(1000000);
    }
    id = potentialID;
  }

  late int id;
  String title;
  List<String> _decisions = [];

  void setDecisions(List<String> decisions) {
    _decisions = decisions;
  }

  List<String> getDecisions() {
    return _decisions;
  }

  void removeDecisionByIndex(int index) {
    if (index >= _decisions.length) {
      return;
    }
    _decisions.removeAt(index);
  }

  String getRandomDecision() {
    if (_decisions.isEmpty) {
      return "";
    }
    return _decisions[Random().nextInt(_decisions.length)];
  }
}

void addDecisionMaker(String title, List<String> decisions) {
  DecisionMaker newDecisionMaker = createDecisionMaker(title, decisions);
  decisionMakers.add(newDecisionMaker);
}

DecisionMaker createDecisionMaker(String title, List<String> decisions) {
  DecisionMaker decisionMaker = DecisionMaker(title: title);
  decisionMaker._decisions = decisions;
  return decisionMaker;
}

void removeDecisionMaker(DecisionMaker decisionMaker) {
  decisionMakers.remove(decisionMaker);
}

const idKey = "ids";

List<DecisionMaker> decisionMakers = [];

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

Future<void> saveDecisionMakers(List<DecisionMaker> decisionMakers) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> decisionMakerIDs = [];

  for (DecisionMaker decisionMaker in decisionMakers) {
    decisionMakerIDs.add(decisionMaker.id.toString());
    await saveDecisionMakerInfo(decisionMaker);
  }

  await prefs.setStringList(idKey, decisionMakerIDs);
}

Future<void> saveDecisionMaker(DecisionMaker decisionMaker) async {
  await saveDecisionMakerID(decisionMaker);
  await saveDecisionMakerInfo(decisionMaker);
}

Future<void> saveDecisionMakerID(DecisionMaker decisionMaker) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String decisionMakerID = decisionMaker.id.toString();

  List<String>? decisionMakerIDs = prefs.getStringList(idKey) ?? [];
  if (!decisionMakerIDs.contains(decisionMakerID)) {
    decisionMakerIDs.add(decisionMakerID);
  }

  await prefs.setStringList(idKey, decisionMakerIDs);
}

Future<void> saveDecisionMakerInfo(DecisionMaker decisionMaker) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString("d_${decisionMaker.id}_title", decisionMaker.title);
  await prefs.setStringList(
      "d_${decisionMaker.id}_decisions", decisionMaker._decisions);
}
