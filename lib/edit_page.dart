import 'package:flutter/material.dart';

import 'decision_makers.dart';

class EditPage extends StatefulWidget {
  const EditPage(
      {super.key, required this.decisionMaker, required this.newDecisionMaker});

  final DecisionMaker decisionMaker;
  final bool newDecisionMaker;

  String getActionText() {
    return newDecisionMaker ? "Create Decision Maker" : "Edit Decision Maker";
  }

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int decisionAmount = 1;

  final TextEditingController titleController = TextEditingController();
  List<TextEditingController> decisionControllers = [];

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.decisionMaker.title;

    return Scaffold(
      appBar: AppBar(title: Text(widget.getActionText())),
      body: Center(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: titleController,
                        maxLength: 40,
                        decoration: const InputDecoration(
                            hintText: "Add a decision maker title"),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Please input a decision option";
                          }
                          return null;
                        },
                      ),
                      createDecisionList(decisionControllers),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              decisionAmount++;
                            });
                          },
                          child: const Icon(Icons.add)),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              List<String> decisions = decisionControllers
                                  .map(
                                    (e) => e.text,
                                  )
                                  .toList();
                              addDecisionMaker(titleController.text, decisions);
                              decisionControllers.map((e) => e.dispose());
                              Navigator.of(context).pop();
                              // TODO: Notify HomePage that it needs to rebuild DecisionMakerList
                            }
                          },
                          child: Text(widget.getActionText()))
                    ],
                  )))),
    );
  }

  ListView createDecisionList(List<TextEditingController> decisionControllers) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: decisionAmount,
      itemBuilder: (context, index) {
        // TODO: Move outside of build function, so they don't get created anew and override current controllers (field values get deleted)
        TextEditingController newController = TextEditingController();
        decisionControllers.add(newController);

        return Row(children: [
          TextFormField(
            controller: newController,
            maxLength: 30,
            decoration: const InputDecoration(
                constraints: BoxConstraints.expand(width: 320, height: 50),
                hintText: "Add a decision option"),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Please input a decision option";
              }
              return null;
            },
          ),
          IconButton(
              onPressed: () {
                if (decisionAmount <= 1) return;
                setState(() {
                  decisionAmount--;
                  // TODO: Remove correct TextFormField
                });
              },
              icon: const Icon(Icons.delete)),
        ]);
      },
    );
  }
}
