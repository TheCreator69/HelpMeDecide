import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/model/sessions.dart';
import 'package:helpmedecide/view/edit_page.dart';

class DecidePage extends StatefulWidget {
  DecidePage({super.key, required this.decisionMakerIndex}) {
    decisionSession = DecisionSession(decisionMakerIndex: decisionMakerIndex);
  }

  final int decisionMakerIndex;
  late final DecisionSession decisionSession;

  @override
  State<DecidePage> createState() => _DecidePageState();
}

class _DecidePageState extends State<DecidePage> {
  final decisionMakersController = Get.find<DecisionMakersController>();

  bool decisionMade = false;

  String getDecisionActionText(BuildContext context) {
    if (decisionMade) {
      return AppLocalizations.of(context)!.decidePageFurtherDecisionActions;
    } else {
      return AppLocalizations.of(context)!.decidePageFirstDecisionAction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.decisionSession.getDecisionMaker().title),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => EditPage(
                      decisionMaker: widget.decisionSession.getDecisionMaker(),
                      isCreatingDecisionMaker: false));
                },
                icon: const Icon(Icons.edit))
          ],
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
                  ? widget.decisionSession.getDecisionText(context)
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
