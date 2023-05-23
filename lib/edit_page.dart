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

  String getFinishSnackbarText() {
    return isCreatingDecisionMaker
        ? "Creation successful!"
        : "Edit successful!";
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
              padding: const EdgeInsets.all(20.0),
              child: Scrollbar(
                  child: ListView(children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0.0),
                            child: TextFormField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 12.0),
                                  border: OutlineInputBorder(),
                                  labelText: "Decision Maker Title"),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Please input a decision maker title";
                                }
                                return null;
                              },
                            )),
                        createDecisionList(decisionControllers),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(4.0),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).hintColor),
                          ),
                          child: const Text("Add decision option"),
                          onPressed: () {
                            saveControllerValuesToDecisionMaker();
                            decisionControllers.add(TextEditingController());
                            setState(() {});
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(4.0),
                          ),
                          child: Text(widget.getFinishButtonText()),
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
                                    widget.decisionMaker.id, title, decisions);
                                DecisionMaker savedDecisionMaker =
                                    DecisionMaker(
                                        id: widget.decisionMaker.id,
                                        title: title);
                                savedDecisionMaker.setDecisions(decisions);
                                saveDecisionMaker(savedDecisionMaker);
                              }
                              decisionControllers.map((e) => e.dispose());

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(widget.getFinishSnackbarText()),
                                duration: const Duration(seconds: 3),
                              ));

                              Navigator.of(context).pop();
                            }
                          },
                        )
                      ],
                    ))
              ])))),
    );
  }

  ListView createDecisionList(List<TextEditingController> decisionControllers) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: decisionControllers.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        TextEditingController currentController = decisionControllers[index];

        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                controller: currentController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 12.0),
                    border: const OutlineInputBorder(),
                    labelText: "Option #${index + 1}",
                    suffixIcon: decisionControllers.length > 2
                        ? IconButton(
                            onPressed: () {
                              decisionControllers.removeAt(index);
                              saveControllerValuesToDecisionMaker();
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete))
                        : const SizedBox()),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please input a decision option";
                  }
                  return null;
                },
              )),
            ]));
      },
    );
  }
}
