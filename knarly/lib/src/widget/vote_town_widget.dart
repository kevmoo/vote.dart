import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/town_folk.dart';
import '../model/vote_town.dart';
import '../view_model/vote_town_editor.dart';

class VoteTownWidget extends StatelessWidget {
  const VoteTownWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTownEditor>(
        builder: (_, notifier, __) {
          final voteTown = notifier.value;

          Widget candidateWidget(TownCandidate candidate) {
            final moving = candidate == notifier.movingCandidate;
            return GestureDetector(
              onPanStart: (DragStartDetails details) =>
                  notifier.moveCandidateStart(candidate),
              onPanUpdate: (DragUpdateDetails event) =>
                  notifier.moveCandidateUpdate(candidate, event.delta),
              onPanEnd: (DragEndDetails details) =>
                  notifier.moveCandidateEnd(candidate),
              child: Container(
                decoration: ShapeDecoration(
                    color: candidate.color,
                    shape: const CircleBorder(),
                    shadows: moving
                        ? _movingCandidateShadows
                        : _stationaryCandidateShadows),
                child: Center(
                  child: Text(
                    candidate.id,
                    textScaleFactor: 1.5,
                    style: moving ? _movingWidgetTextStyle : null,
                  ),
                ),
              ),
            );
          }

          void _lastSizeCallback(Size value) {
            notifier.townSizeRatio = 1 / _offsetMultiplier(value);
          }

          return CustomPaint(
            painter: _VoteTownPainter(voteTown),
            child: Flow(
              children: voteTown.candidates
                  .map(candidateWidget)
                  .toList(growable: false),
              delegate: _CandidateFlowDelegate(voteTown, _lastSizeCallback),
            ),
            isComplex: true,
            willChange: true,
          );
        },
      );

  static const _movingWidgetTextStyle = TextStyle(fontWeight: FontWeight.bold);

  static const _stationaryCandidateShadows = [
    BoxShadow(
      offset: Offset(-1, 1),
      blurRadius: 2,
    ),
  ];

  static const _movingCandidateShadows = [
    BoxShadow(
      offset: Offset(-2, 2),
      blurRadius: 2,
    ),
  ];
}

double _offsetMultiplier(Size size) =>
    math.min(size.height, size.width) /
    (VoteTown.votersAcross * VoteTown.voterSpacing);

class _CandidateFlowDelegate extends FlowDelegate {
  static const _candidateScale = 4.5;

  final VoteTown _voteTown;
  final void Function(Size) _lastSizeCallback;

  _CandidateFlowDelegate(this._voteTown, this._lastSizeCallback);

  @override
  Size getSize(BoxConstraints constraints) {
    var size = constraints.biggest;
    final minDimension = math.min(size.width, size.height);
    size = Size(minDimension, minDimension);
    _lastSizeCallback(size);
    return size;
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    final candidateSize =
        _offsetMultiplier(constraints.biggest) * _candidateScale * 2;
    return BoxConstraints.tightFor(width: candidateSize, height: candidateSize);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final offsetMultiplier = _offsetMultiplier(context.size);

    final centerShift = Offset(
        offsetMultiplier * _candidateScale, offsetMultiplier * _candidateScale);

    for (var i = 0; i < context.childCount; i++) {
      final location = _voteTown.candidates[i].location;
      final shift =
          (Offset(location.x, location.y) * offsetMultiplier) - centerShift;

      context.paintChild(i,
          transform: Matrix4.translationValues(shift.dx, shift.dy, 0));
    }
  }

  @override
  bool shouldRepaint(_CandidateFlowDelegate oldDelegate) =>
      oldDelegate._voteTown != _voteTown;
}

class _VoteTownPainter extends CustomPainter {
  final VoteTown _voteTown;

  _VoteTownPainter(this._voteTown);

  @override
  void paint(Canvas canvas, Size size) {
    final offsetMultiplier = _offsetMultiplier(size);
    final radius = 2.5 * offsetMultiplier;

    for (var voter in _voteTown.voters) {
      canvas.drawCircle(
        Offset(voter.location.x, voter.location.y) * offsetMultiplier,
        radius,
        Paint()..color = voter.closestCandidates.first.darkColor,
      );
    }
  }

  @override
  bool shouldRepaint(_VoteTownPainter oldDelegate) =>
      _voteTown != oldDelegate._voteTown;
}
