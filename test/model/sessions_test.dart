import 'package:flutter_test/flutter_test.dart';
import 'package:helpmedecide/model/sessions.dart';
import 'package:helpmedecide/model/types.dart';

void main() {
  group("EditSession", () {
    test("DecisionMaker should be set correctly", () {
      final DecisionMaker mock = DecisionMaker(id: 69, title: "Mock");
      mock.setDecisions(["0", "1", "2"]);

      EditSession test = EditSession(decisionMaker: mock);
      expect(test.decisionMaker, mock);
    });
  });
}
