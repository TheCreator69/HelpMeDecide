import 'package:flutter/material.dart';

import 'decision_makers.dart';

import 'decide_page.dart';
import 'edit_page.dart';

void main() async {
  //decisionMakers = await loadDecisionMakers();
  DecisionMaker test = DecisionMaker(title: "Test");
  test.setDecisions([
    "Test option",
    "Another option",
    "Even more options",
    "I am running out of options",
    "Penis",
    "This is an option"
  ]);
  decisionMakers.add(test);

  DecisionMaker amogus = DecisionMaker(title: "Amogus");
  amogus.setDecisions([
    "Amoma",
    "Sugugus",
    "BEEF",
    "Amomogusgus",
    "Sugoma",
    "Abominatiogus",
    "Mogus"
  ]);
  decisionMakers.add(amogus);

  runApp(const DecisionApp());
}

class DecisionApp extends StatelessWidget {
  const DecisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Wrap in Provider widget
    return MaterialApp(
      title: "Help me Decide",
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            DecisionMakerList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (() {
          Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
            return EditPage(
              decisionMaker: createDecisionMaker("", []),
              newDecisionMaker: true,
            );
          })));
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum DecisionMakerPopupItem { edit, delete }

class DecisionMakerList extends StatefulWidget {
  const DecisionMakerList({super.key});

  @override
  State<DecisionMakerList> createState() => _DecisionMakerListState();
}

class _DecisionMakerListState extends State<DecisionMakerList> {
  late NotificationListener test;

  @override
  ListView build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: decisionMakers.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.question_mark_rounded),
          title: Text(decisionMakers[index].title),
          trailing: PopupMenuButton<DecisionMakerPopupItem>(
            onSelected: (DecisionMakerPopupItem item) {
              if (item == DecisionMakerPopupItem.edit) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: ((context) {
                  return EditPage(
                    decisionMaker: decisionMakers[index],
                    newDecisionMaker: false,
                  );
                })));
              } else if (item == DecisionMakerPopupItem.delete) {
                setState(() {
                  removeDecisionMaker(decisionMakers[index]);
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<DecisionMakerPopupItem>>[
                const PopupMenuItem<DecisionMakerPopupItem>(
                  value: DecisionMakerPopupItem.edit,
                  child: Text("Edit decision maker"),
                ),
                const PopupMenuItem<DecisionMakerPopupItem>(
                  value: DecisionMakerPopupItem.delete,
                  child: Text("Delete decision maker"),
                )
              ];
            },
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return DecidePage(decisionMaker: decisionMakers[index]);
            })));
          },
        );
      },
      shrinkWrap: true,
    );
  }
}
