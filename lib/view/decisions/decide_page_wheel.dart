import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:helpmedecide/model/controllers.dart';
import 'package:helpmedecide/model/sessions.dart';

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

  final GlobalKey<_AnimatedWheelState> _wheelStateKey =
      GlobalKey<_AnimatedWheelState>();

  bool decisionMade = false;
  bool canPressDecisionButton = true;

  void enableDecisionButton() {
    setState(() {
      canPressDecisionButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.decisionSession.getDecisionMaker().title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Text(
              decisionMade
                  ? (canPressDecisionButton
                      ? widget.decisionSession.getDecisionText(context)
                      : AppLocalizations.of(context)!
                          .decidePageWheelDecisionInProgress)
                  : AppLocalizations.of(context)!.decidePageNoDecisionYet,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: AnimatedWheel(
                key: _wheelStateKey,
                decisionMakerIndex: widget.decisionMakerIndex,
                enableButton: enableDecisionButton,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            SizedBox(
                height: 100.0,
                child: ElevatedButton(
                    onPressed: canPressDecisionButton
                        ? () {
                            int oldDecisionIndex =
                                widget.decisionSession.decisionIndex;
                            widget.decisionSession.makeDecision();

                            setState(() {
                              decisionMade = true;
                              canPressDecisionButton = false;

                              _wheelStateKey.currentState?.playSpinAnimation(
                                  oldDecisionIndex,
                                  widget.decisionSession.decisionIndex,
                                  widget.decisionSession
                                      .getDecisionMaker()
                                      .getAmountOfDecisions());
                            });
                          }
                        : null,
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
  const AnimatedWheel(
      {super.key,
      required this.decisionMakerIndex,
      required this.enableButton});

  final int decisionMakerIndex;
  final VoidCallback enableButton;

  @override
  State<AnimatedWheel> createState() => _AnimatedWheelState();
}

class _AnimatedWheelState extends State<AnimatedWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween<double> _rotationInterp;
  late Animation<double> _rotationAnimation;

  void playSpinAnimation(int oldIndex, int newIndex, int sections) {
    double rotationEnd = _calculateTweenEnd(oldIndex, newIndex, sections);

    _rotationInterp =
        Tween<double>(begin: _rotationInterp.end, end: rotationEnd);
    _rotationAnimation = _rotationInterp
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(_animationController);

    _animationController.reset();
    _animationController.forward();
    setState(() {});
  }

  double _calculateTweenEnd(int oldIndex, int newIndex, int sections) {
    double turnAmountPerSection = 1.0 / sections;

    int noWrapDistance = oldIndex - newIndex;
    int wrapDistance = sections - (newIndex - oldIndex);
    /*
    A "wrap" occurs if the wheel goes over the segment with index 0 while doing the initial turn
    Indices increase clockwise, but the wheel rotates counter-clockwise.
    That's why a wrap occurs when the new index is larger than the old index, contrary to a circular array.
    */
    int sectionsToTravel = newIndex > oldIndex ? wrapDistance : noWrapDistance;

    int additonalTurns = 3;

    return _rotationInterp.end! +
        sectionsToTravel * turnAmountPerSection +
        additonalTurns;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.enableButton();
      }
    });

    _rotationInterp = Tween<double>(begin: 0.0, end: 0.0);
    _rotationAnimation = _rotationInterp.animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotationAnimation,
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
    return CustomPaint(
      painter: WheelPainter(
        sections: decisionMakersController
            .getDecisionMakerAt(decisionMakerIndex)
            .getAmountOfDecisions(),
        sectionColors: chosenColors,
        sectionLabels: shortenedDecisions,
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
      // The subtraction is done so that the wheel starts with index 0 segment in the top center
      final startAngle = i * sectionAngle - (pi / 2 + sectionAngle / 2);

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
