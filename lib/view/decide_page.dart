import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/model/sessions.dart';
import 'package:helpmedecide/model/types.dart';
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

  DecisionMaker getDecisionMaker() {
    return decisionMakersController
        .getDecisionMakerAt(widget.decisionMakerIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getDecisionMaker().title),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => EditPage(
                      decisionMaker: getDecisionMaker(),
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
              widget.decisionSession.getDecisionText(context),
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
                      setState(() {});
                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(4.0),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero))),
                    child: Text(
                        widget.decisionSession.getDecisionActionText(context),
                        style: const TextStyle(fontSize: 24)))),
          ],
        ));
  }
}
