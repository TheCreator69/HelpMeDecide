import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/model/sessions.dart';
import 'package:helpmedecide/model/types.dart';

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

  String getDialogTitleText(BuildContext context) {
    return isCreatingDecisionMaker
        ? AppLocalizations.of(context)!.editPageCancelDialogTitleCreate
        : AppLocalizations.of(context)!.editPageCancelDialogTitleEdit;
  }

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final decisionMakersController = Get.find<DecisionMakersController>();
  final storageController = Get.find<StorageController>();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  DecisionMaker getDecisionMaker() {
    return widget.decisionMaker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.getPageTitleText(context)),
        ),
        body: WillPopScope(
          onWillPop: () async {
            bool answer = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(widget.getDialogTitleText(context)),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(AppLocalizations.of(context)!
                                    .editPageCancelDialogNo)),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(AppLocalizations.of(context)!
                                    .editPageCancelDialogYes)),
                          ],
                        )) ??
                false;
            return answer;
          },
          child: Center(
              child: Scrollbar(
                  child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 0.0),
                                        child: TextFormField(
                                          controller: widget
                                              .editSession.titleController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 12.0),
                                              border:
                                                  const OutlineInputBorder(),
                                              labelText:
                                                  AppLocalizations.of(context)!
                                                      .editPageTitleLabel),
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return AppLocalizations.of(
                                                      context)!
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
                                          AppLocalizations.of(context)!
                                              .editPageAddOption,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        textColor: Theme.of(context).hintColor,
                                        onTap: () {
                                          _listKey.currentState?.insertItem(
                                            widget.editSession
                                                .decisionControllers.length,
                                            duration: const Duration(
                                                milliseconds: 150),
                                          );
                                          widget.editSession
                                              .addDecisionController();
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
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            String title = widget.editSession
                                                .titleController.text;
                                            List<String> decisions = widget
                                                .editSession.decisionControllers
                                                .map(
                                                  (e) => e.text,
                                                )
                                                .toList();
                                            if (widget
                                                .isCreatingDecisionMaker) {
                                              DecisionMaker maker =
                                                  decisionMakersController
                                                      .createDecisionMaker(
                                                          title, decisions);
                                              decisionMakersController
                                                  .addDecisionMaker(maker);
                                              storageController
                                                  .saveDecisionMaker(maker);
                                            } else {
                                              decisionMakersController
                                                  .changeDecisionMaker(
                                                      widget.decisionMaker.id,
                                                      title,
                                                      decisions);
                                              DecisionMaker savedDecisionMaker =
                                                  DecisionMaker(
                                                      id: widget
                                                          .decisionMaker.id,
                                                      title: title);
                                              savedDecisionMaker
                                                  .setDecisions(decisions);
                                              storageController
                                                  .saveDecisionMaker(
                                                      savedDecisionMaker);
                                            }
                                            widget.editSession
                                                .disposeOfControllers();

                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ))
                          ])))),
        ));
  }

  AnimatedList createDecisionList() {
    return AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      initialItemCount: widget.editSession.decisionControllers.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index, animation) {
        TextEditingController currentController =
            widget.editSession.decisionControllers[index];

        return SlideTransition(
            position: animation
                .drive(Tween(begin: const Offset(1, 0), end: Offset.zero)),
            child: DecisionListFormField(
              index: index,
              controller: currentController,
              editSession: widget.editSession,
            ));
      },
    );
  }
}

class DecisionListFormField extends StatefulWidget {
  const DecisionListFormField(
      {super.key,
      required this.index,
      required this.controller,
      required this.editSession});

  final int index;
  final TextEditingController controller;
  final EditSession editSession;

  @override
  State<DecisionListFormField> createState() => _DecisionListFormFieldState();
}

class _DecisionListFormFieldState extends State<DecisionListFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: Row(children: [
          Expanded(
              child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!
                    .editPageOptionLabel(widget.index + 1),
                suffixIcon: widget.editSession.decisionControllers.length > 2
                    ? IconButton(
                        onPressed: () {
                          AnimatedList.of(context).removeItem(
                              widget.index,
                              duration: const Duration(milliseconds: 150),
                              (context, animation) => SlideTransition(
                                  position: animation.drive(Tween(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero)),
                                  child: DecisionListFormField(
                                    index: widget.index,
                                    controller: widget.controller,
                                    editSession: widget.editSession,
                                  )));
                          widget.editSession
                              .removeDecisionControllerAt(widget.index);
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
  }
}
