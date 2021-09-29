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

          void _lastSizeCallback(Size value) {
            notifier.townSizeRatio = 1 / _offsetMultiplier(value);
          }

          return CustomPaint(
            painter: _VoteTownPainter(voteTown),
            isComplex: true,
            willChange: true,
            child: Flow(
              delegate: _CandidateFlowDelegate(voteTown, _lastSizeCallback),
              children: voteTown.candidates
                  .map((c) => _CandidateWidget(candidate: c))
                  .toList(growable: false),
            ),
          );
        },
      );
}

const _candidateScale = 4.7;

class _CandidateWidget extends StatelessWidget {
  final TownCandidate candidate;
  const _CandidateWidget({Key? key, required this.candidate}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<VoteTownEditor>(
        builder: (_, notifier, __) {
          final moving = candidate == notifier.movingCandidate;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onPanStart: (DragStartDetails details) =>
                  notifier.moveCandidateStart(candidate),
              onPanUpdate: (DragUpdateDetails event) =>
                  notifier.moveCandidateUpdate(candidate, event.delta),
              onPanEnd: (DragEndDetails details) =>
                  notifier.moveCandidateEnd(candidate),
              child: Container(
                decoration: ShapeDecoration(
                  color: candidate.color,
                  shape: const ContinuousRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(_candidateScale * 6)),
                  ),
                  shadows: moving
                      ? _movingCandidateShadows
                      : _stationaryCandidateShadows,
                ),
                child: Center(
                  child: Text(
                    candidate.id,
                    textScaleFactor: 1.5,
                    style: moving ? _movingWidgetTextStyle : null,
                  ),
                ),
              ),
            ),
          );
        },
      );

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

  static const _movingWidgetTextStyle = TextStyle(fontWeight: FontWeight.bold);
}

double _offsetMultiplier(Size size) =>
    math.min(size.height, size.width) /
    (VoteTown.votersAcross * VoteTown.voterSpacing);

class _CandidateFlowDelegate extends FlowDelegate {
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
      offsetMultiplier * _candidateScale,
      offsetMultiplier * _candidateScale,
    );

    for (var i = 0; i < context.childCount; i++) {
      final location = _voteTown.candidates[i].location;
      final shift =
          (Offset(location.x, location.y) * offsetMultiplier) - centerShift;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(shift.dx, shift.dy, 0),
      );
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
