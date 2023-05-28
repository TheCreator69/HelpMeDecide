import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'about_page.dart';
import 'decide_page.dart';
import 'edit_page.dart';

import '../model/controllers.dart';
import '../model/decision_maker.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final storageController = Get.find<StorageController>();
    final decisionMakersController = Get.find<DecisionMakersController>();

    List<DecisionMaker> loadedList = storageController.loadDecisionMakers();
    print(loadedList);
    decisionMakersController.setDecisionMakers(loadedList);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Decide what to decide"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const AboutPage());
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: const DecisionMakerListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Get.to(() => EditPage(
                decisionMaker:
                    decisionMakersController.createDecisionMaker("", []),
                isCreatingDecisionMaker: true,
              ));
        }),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class DecisionMakerListView extends StatefulWidget {
  const DecisionMakerListView({super.key});

  @override
  State<DecisionMakerListView> createState() => _DecisionMakerListViewState();
}

class _DecisionMakerListViewState extends State<DecisionMakerListView> {
  @override
  Widget build(BuildContext context) {
    final decisionMakersController = Get.find<DecisionMakersController>();

    return Obx(
      () => Scrollbar(
          child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        itemCount: decisionMakersController.getAmountOfDecisionMakers(),
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
              elevation: 2.0,
              child: ListTile(
                leading: const Icon(Icons.question_mark_rounded),
                title: Text(
                    decisionMakersController.getDecisionMakerAt(index).title),
                horizontalTitleGap: 0.0,
                trailing: DecisionMakerPopupButton(index: index),
                onTap: () {
                  Get.to(() => DecidePage(
                      decisionMaker:
                          decisionMakersController.getDecisionMakerAt(index)));
                },
              ));
        },
      )),
    );
  }
}

enum DecisionMakerPopupItem { edit, delete }

class DecisionMakerPopupButton extends StatelessWidget {
  const DecisionMakerPopupButton({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final decisionMakersController = Get.find<DecisionMakersController>();
    final storageController = Get.find<StorageController>();

    return PopupMenuButton<DecisionMakerPopupItem>(
      onSelected: (DecisionMakerPopupItem item) {
        if (item == DecisionMakerPopupItem.edit) {
          Get.to(() => EditPage(
                decisionMaker:
                    decisionMakersController.getDecisionMakerAt(index),
                isCreatingDecisionMaker: false,
              ));
        } else if (item == DecisionMakerPopupItem.delete) {
          DecisionMaker maker =
              decisionMakersController.getDecisionMakerAt(index);
          storageController.saveRemovalOfDecisionMaker(maker);
          decisionMakersController.removeDecisionMaker(maker);
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<DecisionMakerPopupItem>>[
          const PopupMenuItem<DecisionMakerPopupItem>(
            value: DecisionMakerPopupItem.edit,
            child: ListTile(
                leading: Icon(Icons.mode_edit),
                title: Text("Edit decision maker")),
          ),
          const PopupMenuItem<DecisionMakerPopupItem>(
              value: DecisionMakerPopupItem.delete,
              child: ListTile(
                leading: Icon(Icons.delete, color: Color(0xFFFF3300)),
                title: Text("Delete decision maker",
                    style: TextStyle(color: Color(0xFFFF3300))),
              )),
        ];
      },
    );
  }
}
