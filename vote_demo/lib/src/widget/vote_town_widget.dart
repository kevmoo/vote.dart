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

          final flowDelegate = _CandidateFlowDelegate(voteTown);

          bool dragListener(_CandidateDragNotification notification) {
            final details = notification.details;

            if (details is DragStartDetails) {
              notifier.moveCandidateStart(notification.candidate);
            } else if (details is DragUpdateDetails) {
              final scale = 1 / _offsetMultiplier(flowDelegate._drawSize);
              final newValue = details.delta * scale;

              notifier.moveCandidateUpdate(
                notification.candidate,
                newValue,
              );
            } else if (details is DragEndDetails) {
              notifier.moveCandidateEnd(notification.candidate);
            } else {
              throw UnsupportedError(
                'We do not support details of type '
                '${details.runtimeType} ($details).',
              );
            }

            return true;
          }

          return Column(
            children: [
              CustomPaint(
                painter: _VoteTownPainter(voteTown),
                isComplex: true,
                willChange: true,
                child: NotificationListener<_CandidateDragNotification>(
                  onNotification: dragListener,
                  child: Flow(
                    delegate: flowDelegate,
                    children: voteTown.candidates
                        .map((c) => _CandidateWidget(candidate: c))
                        .toList(growable: false),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: notifier.removeCandidate,
                    child: const Text('Remove candidate'),
                  ),
                  OutlinedButton(
                    onPressed: notifier.addCandidate,
                    child: const Text('Add candidate'),
                  ),
                ],
              ),
            ],
          );
        },
      );
}

const _candidateScale = 4.7;

class _CandidateDragNotification extends Notification {
  final Object details;
  final TownCandidate candidate;

  const _CandidateDragNotification(this.candidate, this.details);
}

class _CandidateWidget extends StatelessWidget {
  final TownCandidate candidate;
  const _CandidateWidget({Key? key, required this.candidate}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<VoteTownEditor>(
        builder: (context, model, __) {
          void handler(Object details) =>
              _CandidateDragNotification(candidate, details).dispatch(context);

          final moving = candidate == model.movingCandidate;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onPanStart: handler,
              onPanUpdate: handler,
              onPanEnd: handler,
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
  Size _drawSize = Size.zero;
  final VoteTown _voteTown;

  _CandidateFlowDelegate(this._voteTown);

  @override
  Size getSize(BoxConstraints constraints) {
    final size = constraints.biggest;
    final minDimension = math.min(size.width, size.height);
    return _drawSize = Size(minDimension, minDimension);
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
  bool shouldRepaint(_CandidateFlowDelegate oldDelegate) {
    // Make sure the previous draw scale is obtained by the new delegate!
    _drawSize = oldDelegate._drawSize;
    return oldDelegate._voteTown != _voteTown;
  }
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
