import 'package:flutter/material.dart';

import 'decision_makers.dart';
import 'main.dart';

class EditPage extends StatefulWidget {
  const EditPage(
      {super.key,
      required this.decisionMaker,
      required this.isCreatingDecisionMaker});

  final DecisionMaker decisionMaker;
  final bool isCreatingDecisionMaker;

  String getPageTitleText() {
    return isCreatingDecisionMaker
        ? "Create Decision Maker"
        : "Edit Decision Maker";
  }

  String getFinishButtonText() {
    return isCreatingDecisionMaker ? "Finish Creating" : "Finish Editing";
  }

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  List<TextEditingController> decisionControllers = [];

  DecisionMaker getDecisionMaker() {
    return widget.decisionMaker;
  }

  // Somehow circumvent having to save & load values from decisionMaker to controllers every time
  void saveControllerValuesToDecisionMaker() {
    widget.decisionMaker.title = titleController.text;
    List<String> decisions =
        decisionControllers.map((controller) => controller.text).toList();
    widget.decisionMaker.setDecisions(decisions);
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.decisionMaker.title;

    if (widget.decisionMaker.getDecisions().isEmpty) {
      decisionControllers = [TextEditingController(), TextEditingController()];
    } else {
      for (int i = 0; i < widget.decisionMaker.getDecisions().length; i++) {
        late TextEditingController currentController;
        if (i >= decisionControllers.length) {
          currentController = TextEditingController();
          decisionControllers.add(currentController);
        } else {
          currentController = decisionControllers[i];
        }

        currentController.text = widget.decisionMaker.getDecisionAt(i);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.getPageTitleText())),
      body: Center(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                              hintText: "Add a decision maker title"),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Please input a decision maker title";
                            }
                            return null;
                          },
                        ),
                        createDecisionList(decisionControllers),
                        ElevatedButton(
                            onPressed: () {
                              saveControllerValuesToDecisionMaker();
                              decisionControllers.add(TextEditingController());
                              setState(() {});
                            },
                            child: const Text("Add decision option")),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String title = titleController.text;
                                List<String> decisions = decisionControllers
                                    .map(
                                      (e) => e.text,
                                    )
                                    .toList();
                                if (widget.isCreatingDecisionMaker) {
                                  DecisionMaker maker = decisionMakerList
                                      .createDecisionMaker(title, decisions);
                                  decisionMakerList.addDecisionMaker(maker);
                                  saveDecisionMaker(maker);
                                } else {
                                  decisionMakerList.changeDecisionMaker(
                                      widget.decisionMaker.id,
                                      title,
                                      decisions);
                                  DecisionMaker savedDecisionMaker =
                                      DecisionMaker(
                                          id: widget.decisionMaker.id,
                                          title: title);
                                  savedDecisionMaker.setDecisions(decisions);
                                  saveDecisionMaker(savedDecisionMaker);
                                }
                                decisionControllers.map((e) => e.dispose());
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(widget.getFinishButtonText()))
                      ],
                    ))
              ]))),
    );
  }

  ListView createDecisionList(List<TextEditingController> decisionControllers) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: decisionControllers.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        TextEditingController currentController = decisionControllers[index];

        return Row(children: [
          Expanded(
              child: TextFormField(
            controller: currentController,
            decoration:
                const InputDecoration(hintText: "Add a decision option"),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please input a decision option";
              }
              return null;
            },
          )),
          IconButton(
              onPressed: () {
                if (decisionControllers.length <= 2) return;
                decisionControllers.removeAt(index);
                saveControllerValuesToDecisionMaker();
                setState(() {});
              },
              icon: const Icon(Icons.delete)),
        ]);
      },
    );
  }
}
