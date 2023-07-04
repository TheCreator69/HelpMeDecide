import 'package:flutter_test/flutter_test.dart';
import 'package:helpmedecide/model/sessions.dart';
import 'package:helpmedecide/model/types.dart';

void main() {
  group("DecisionSession", () {
    test("DecisionMaker should be set correctly", () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Stub");
      DecisionSession test = DecisionSession(decisionMaker: stub);

      expect(test.decisionMaker, stub);
    });

    test("No decisions should be set on creation", () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Stub");
      DecisionSession test = DecisionSession(decisionMaker: stub);

      expect(test.previousDecisions.length, 0);
    });

    test("Previous decisions should be increased by one after making decision",
        () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Stub");
      stub.setDecisions(["0", "1"]);
      DecisionSession test = DecisionSession(decisionMaker: stub);
      test.makeDecision();

      expect(test.previousDecisions.length, 1);
    });

    test(
        "Previous decisions should only contain last decision index after every index has been chosen",
        () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Stub");
      stub.setDecisions(["0", "1", "2"]);
      DecisionSession test = DecisionSession(decisionMaker: stub);
      test.makeDecision();
      test.makeDecision();
      test.makeDecision();

      expect(test.previousDecisions.length, 1);
      expect(test.previousDecisions[0], test.decisionIndex);
    });

    test(
        "First decision index after each index has been picked once should not be equal to the picked index before",
        () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Stub");
      stub.setDecisions(["0", "1", "2"]);
      DecisionSession test = DecisionSession(decisionMaker: stub);
      test.makeDecision();
      test.makeDecision();
      test.makeDecision();
      int pickedIndexBefore = test.decisionIndex;
      test.makeDecision();

      expect(test.decisionIndex, isNot(pickedIndexBefore));
    });
  });

  group("EditSession", () {
    test("DecisionMaker should be set correctly", () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Stub");
      EditSession test = EditSession(decisionMaker: stub);

      expect(test.decisionMaker, stub);
    });

    test("TitleController's text should be equal to DecisionMaker's title", () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Title");
      EditSession test = EditSession(decisionMaker: stub);

      expect(test.titleController.text, stub.title);
    });

    test(
        "Two TextEditingControllers should be created for empty DecisionMakers",
        () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Title");
      EditSession test = EditSession(decisionMaker: stub);

      expect(test.decisionControllers.length, 2);
    });

    test(
        "Amount of TextEditingControllers should match amount of decisions of DecisionMaker",
        () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Title");
      stub.setDecisions(["1", "2", "3", "4"]);
      EditSession test = EditSession(decisionMaker: stub);

      expect(test.decisionControllers.length, 4);
    });

    test(
        "Text of TextEditingControllers should match decision string at each index",
        () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Title");
      stub.setDecisions(["0", "1", "2"]);
      EditSession test = EditSession(decisionMaker: stub);

      expect(test.decisionControllers[0].text, "0");
      expect(test.decisionControllers[1].text, "1");
      expect(test.decisionControllers[2].text, "2");
    });

    test("Amount of TextEditingControllers should increase by 1", () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Title");
      stub.setDecisions(["0", "1", "2"]);
      EditSession test = EditSession(decisionMaker: stub);
      test.addDecisionController();

      expect(test.decisionControllers.length, 4);
    });

    test("Amount of TextEditingControllers should decrease by 1", () {
      final DecisionMaker stub = DecisionMaker(id: 69, title: "Title");
      stub.setDecisions(["0", "1", "2"]);
      EditSession test = EditSession(decisionMaker: stub);
      test.removeDecisionControllerAt(2);

      expect(test.decisionControllers.length, 2);
    });
  });
}
