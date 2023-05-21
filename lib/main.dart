import 'package:flutter/material.dart';

import 'decision_makers.dart';

import 'decide_page.dart';
import 'edit_page.dart';

DecisionMakerListModel decisionMakerList = DecisionMakerListModel();

void main() async {
  runApp(const DecisionApp());

  List<DecisionMaker> loadedList = await loadDecisionMakers();
  decisionMakerList.setDecisionMakers(loadedList);
}

class DecisionApp extends StatelessWidget {
  const DecisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Help me Decide",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Decide what to decide"),
      ),
      body: const Scrollbar(child: DecisionMakerListView()),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
            return EditPage(
              decisionMaker: decisionMakerList.createDecisionMaker("", []),
              isCreatingDecisionMaker: true,
            );
          })));
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum DecisionMakerPopupItem { edit, delete }

class DecisionMakerListView extends StatefulWidget {
  const DecisionMakerListView({super.key});

  @override
  State<DecisionMakerListView> createState() => _DecisionMakerListViewState();
}

class _DecisionMakerListViewState extends State<DecisionMakerListView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: decisionMakerList,
        builder: ((context, child) {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: decisionMakerList.getAmountOfDecisionMakers(),
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.question_mark_rounded),
                title: Text(decisionMakerList.getDecisionMakerAt(index).title),
                trailing: PopupMenuButton<DecisionMakerPopupItem>(
                  onSelected: (DecisionMakerPopupItem item) {
                    if (item == DecisionMakerPopupItem.edit) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: ((context) {
                        return EditPage(
                          decisionMaker:
                              decisionMakerList.getDecisionMakerAt(index),
                          isCreatingDecisionMaker: false,
                        );
                      })));
                    } else if (item == DecisionMakerPopupItem.delete) {
                      DecisionMaker maker =
                          decisionMakerList.getDecisionMakerAt(index);
                      saveRemovalOfDecisionMaker(maker);
                      setState(() {
                        decisionMakerList.removeDecisionMaker(maker);
                      });
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
                            leading: Icon(Icons.delete),
                            title: Text("Delete decision maker")),
                      )
                    ];
                  },
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return DecidePage(
                        decisionMaker:
                            decisionMakerList.getDecisionMakerAt(index));
                  })));
                },
              );
            },
          );
        }));
  }
}
