import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/model/sessions.dart';
import 'package:helpmedecide/model/types.dart';

class DecidePageClassic extends StatefulWidget {
  DecidePageClassic({super.key, required this.decisionMaker}) {
    decisionSession = DecisionSession(decisionMaker: decisionMaker);
  }

  final DecisionMaker decisionMaker;
  late final DecisionSession decisionSession;

  @override
  State<DecidePageClassic> createState() => _DecidePageClassicState();
}

class _DecidePageClassicState extends State<DecidePageClassic> {
  final decisionMakersController = Get.find<DecisionMakersController>();

  bool decisionMade = false;

  String getDecisionActionText(BuildContext context) {
    if (decisionMade) {
      return AppLocalizations.of(context)!
          .decidePageClassicFurtherDecisionActions;
    } else {
      return AppLocalizations.of(context)!.decidePageClassicFirstDecisionAction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.decisionMaker.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Text(
              decisionMade
                  ? widget.decisionSession.getDecisionText()
                  : AppLocalizations.of(context)!.decidePageNoDecisionYet,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(),
            ),
            SizedBox(
                height: 100.0,
                child: ElevatedButton(
                    onPressed: () {
                      widget.decisionSession.makeDecision();
                      setState(() {
                        decisionMade = true;
                      });
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(4.0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero))),
                    child: Text(getDecisionActionText(context),
                        style: const TextStyle(fontSize: 24)))),
          ],
        ));
  }
}
