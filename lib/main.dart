import 'package:flutter/material.dart';
import 'package:helpmedecide/about.dart';

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
        useMaterial3: true,
        colorScheme: const ColorScheme.light(),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(),
        brightness: Brightness.dark,
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              },
              icon: const Icon(Icons.info))
        ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
              return Card(
                  elevation: 2.0,
                  child: ListTile(
                    leading: const Icon(Icons.question_mark_rounded),
                    title:
                        Text(decisionMakerList.getDecisionMakerAt(index).title),
                    horizontalTitleGap: 0.0,
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

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Removed decision maker '${maker.title}'"),
                            duration: const Duration(seconds: 3),
                          ));

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
                                leading: Icon(Icons.delete,
                                    color: Color(0xFFFF3300)),
                                title: Text("Delete decision maker",
                                    style: TextStyle(color: Color(0xFFFF3300))),
                              )),
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
                  ));
            },
          );
        }));
  }
}
