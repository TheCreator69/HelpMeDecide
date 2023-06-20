import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/sessions.dart';

import '../model/controllers.dart';
import '../model/types.dart';

class EditPage extends StatefulWidget {
  EditPage(
      {super.key,
      required this.decisionMaker,
      required this.isCreatingDecisionMaker}) {
    editSession = EditSession(decisionMaker: decisionMaker);
  }

  final DecisionMaker decisionMaker;
  final bool isCreatingDecisionMaker;

  late final EditSession editSession;

  String getPageTitleText(BuildContext context) {
    return isCreatingDecisionMaker
        ? AppLocalizations.of(context)!.editPageTitleCreate
        : AppLocalizations.of(context)!.editPageTitleEdit;
  }

  String getFinishButtonText(BuildContext context) {
    return isCreatingDecisionMaker
        ? AppLocalizations.of(context)!.editPageFinishCreate
        : AppLocalizations.of(context)!.editPageFinishEdit;
  }

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final decisionMakersController = Get.find<DecisionMakersController>();
  final storageController = Get.find<StorageController>();

  DecisionMaker getDecisionMaker() {
    return widget.decisionMaker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.getPageTitleText(context)),
      ),
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
                              controller: widget.editSession.titleController,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 12.0),
                                  border: const OutlineInputBorder(),
                                  labelText: AppLocalizations.of(context)!
                                      .editPageTitleLabel),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .editPageTitleInvalid;
                                }
                                return null;
                              },
                            )),
                        createDecisionList(),
                        Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: const Icon(Icons.add),
                            title: Text(
                              AppLocalizations.of(context)!.editPageAddOption,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            textColor: Theme.of(context).hintColor,
                            onTap: () {
                              widget.editSession.addDecisionController();
                              setState(() {});
                            },
                          ),
                        ),
                        Card(
                          elevation: 4.0,
                          child: ListTile(
                            leading: const Icon(Icons.check),
                            title: Text(
                              widget.getFinishButtonText(context),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                String title =
                                    widget.editSession.titleController.text;
                                List<String> decisions =
                                    widget.editSession.decisionControllers
                                        .map(
                                          (e) => e.text,
                                        )
                                        .toList();
                                if (widget.isCreatingDecisionMaker) {
                                  DecisionMaker maker = decisionMakersController
                                      .createDecisionMaker(title, decisions);
                                  decisionMakersController
                                      .addDecisionMaker(maker);
                                  storageController.saveDecisionMaker(maker);
                                } else {
                                  decisionMakersController.changeDecisionMaker(
                                      widget.decisionMaker.id,
                                      title,
                                      decisions);
                                  DecisionMaker savedDecisionMaker =
                                      DecisionMaker(
                                          id: widget.decisionMaker.id,
                                          title: title);
                                  savedDecisionMaker.setDecisions(decisions);
                                  storageController
                                      .saveDecisionMaker(savedDecisionMaker);
                                }
                                widget.editSession.disposeOfControllers();

                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ))
              ])))),
    );
  }

  ListView createDecisionList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.editSession.decisionControllers.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        TextEditingController currentController =
            widget.editSession.decisionControllers[index];

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
                    labelText: AppLocalizations.of(context)!
                        .editPageOptionLabel(index + 1),
                    suffixIcon:
                        widget.editSession.decisionControllers.length > 2
                            ? IconButton(
                                onPressed: () {
                                  widget.editSession
                                      .removeDecisionControllerAt(index);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete))
                            : const SizedBox()),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.editPageOptionInvalid;
                  }
                  return null;
                },
              )),
            ]));
      },
    );
  }
}
