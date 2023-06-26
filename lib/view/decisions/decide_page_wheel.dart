import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/model/sessions.dart';
import 'package:helpmedecide/view/edit_page.dart';

class DecidePageWheel extends StatefulWidget {
  DecidePageWheel({super.key, required this.decisionMakerIndex}) {
    decisionSession = DecisionSession(decisionMakerIndex: decisionMakerIndex);
  }

  final int decisionMakerIndex;
  late final DecisionSession decisionSession;

  @override
  State<DecidePageWheel> createState() => _DecidePageWheelState();
}

class _DecidePageWheelState extends State<DecidePageWheel> {
  final decisionMakersController = Get.find<DecisionMakersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.decisionSession.getDecisionMaker().title),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => EditPage(
                      decisionMaker: widget.decisionSession.getDecisionMaker(),
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
              flex: 2,
              child: Container(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: AnimatedWheel(
                decisionMakerIndex: widget.decisionMakerIndex,
              ),
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
                        AppLocalizations.of(context)!
                            .decidePageWheelDecisionAction,
                        style: const TextStyle(fontSize: 24)))),
          ],
        ));
  }
}

class AnimatedWheel extends StatefulWidget {
  const AnimatedWheel({super.key, required this.decisionMakerIndex});

  final int decisionMakerIndex;

  @override
  State<AnimatedWheel> createState() => _AnimatedWheelState();
}

class _AnimatedWheelState extends State<AnimatedWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    //_animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _curvedAnimation,
      child: WheelBuilder(decisionMakerIndex: widget.decisionMakerIndex),
    );
  }
}

class WheelBuilder extends StatelessWidget {
  WheelBuilder({super.key, required this.decisionMakerIndex}) {
    int decisionCount = decisionMakersController
        .getDecisionMakerAt(decisionMakerIndex)
        .getAmountOfDecisions();

    if (decisionCount % 5 == 1) {
      chosenColors = List<Color>.from(colorPalette).sublist(0, 4);
    } else {
      chosenColors = List<Color>.from(colorPalette).sublist(0, 5);
    }

    shortenedDecisions = List<String>.from(decisionMakersController
            .getDecisionMakerAt(decisionMakerIndex)
            .getDecisions())
        .map((decision) {
      if (decision.length < 15) {
        return decision;
      } else {
        return "${decision.substring(0, 15)}...";
      }
    }).toList();
  }

  final decisionMakersController = Get.find<DecisionMakersController>();
  final int decisionMakerIndex;

  final List<Color> colorPalette = [
    Colors.red,
    Colors.blue,
    Colors.green,
    const Color.fromRGBO(236, 217, 42, 1),
    Colors.indigo,
  ];
  late final List<Color> chosenColors;

  late final List<String> shortenedDecisions;

  @override
  Widget build(BuildContext context) {
    return WheelOfFortune(
        sections: decisionMakersController
            .getDecisionMakerAt(decisionMakerIndex)
            .getAmountOfDecisions(),
        sectionColors: chosenColors,
        sectionLabels: shortenedDecisions);
  }
}

class WheelOfFortune extends StatelessWidget {
  final List<Color> sectionColors;
  final List<String> sectionLabels;
  final int sections;

  const WheelOfFortune(
      {super.key,
      required this.sections,
      required this.sectionColors,
      required this.sectionLabels});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WheelPainter(
        sections: sections,
        sectionColors: sectionColors,
        sectionLabels: sectionLabels,
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final int sections;
  final List<Color> sectionColors;
  final List<String> sectionLabels;

  WheelPainter(
      {required this.sections,
      required this.sectionColors,
      required this.sectionLabels});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final sectionAngle = 2 * pi / sections;

    for (var i = 0; i < sections; i++) {
      final startAngle = i * sectionAngle;

      final circleSegment = Path()
        ..moveTo(centerX, centerY)
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sectionAngle,
          false,
        )
        ..close();

      final segmentColor = Paint()
        ..color = sectionColors[i % sectionColors.length];
      canvas.drawPath(circleSegment, segmentColor);

      final label = sectionLabels[i % sectionLabels.length];
      final labelAngle = startAngle + sectionAngle / 2;

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textX = centerX + radius * 0.25 * cos(labelAngle - 0.25);
      final textY = centerY + radius * 0.25 * sin(labelAngle - 0.25);

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(labelAngle);

      textPainter.paint(canvas, Offset.zero);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
