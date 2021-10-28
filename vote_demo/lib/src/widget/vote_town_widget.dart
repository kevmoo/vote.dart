import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_widgets/vote_widgets.dart';

import '../model/town_folk.dart';
import '../model/vote_town.dart';
import '../view_model/vote_town_editor.dart';

class VoteTownWidget extends StatelessWidget {
  const VoteTownWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTownEditor>(
        builder: (_, editor, __) {
          final voteTown = editor.value;

          final flowDelegate = _CandidateFlowDelegate(voteTown);

          bool dragListener(_CandidateDragNotification notification) {
            final details = notification.details;

            if (details is DragStartDetails) {
              editor.moveCandidateStart(notification.candidate);
            } else if (details is DragUpdateDetails) {
              final scale = 1 / _offsetMultiplier(flowDelegate._drawSize);
              final newValue = details.delta * scale;

              editor.moveCandidateUpdate(
                notification.candidate,
                newValue,
              );
            } else if (details is DragEndDetails) {
              editor.moveCandidateEnd(notification.candidate);
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
              Consumer<VoteNotification?>(
                builder: (ctx, notification, child) {
                  int? countForCandidate(TownCandidate candidate) {
                    if (notification == null) {
                      return voteTown.pluralityElection.places
                          .singleWhere((element) => element.contains(candidate))
                          .voteCount;
                    }

                    return voteTown.voters
                        .where(
                          (voter) =>
                              voter.closestCandidates
                                  .where(notification.relatedTo)
                                  .firstOrNull ==
                              candidate,
                        )
                        .length;
                  }

                  return CustomPaint(
                    painter: _VoteTownPainter(voteTown, notification),
                    isComplex: true,
                    willChange: true,
                    child: NotificationListener<_CandidateDragNotification>(
                      onNotification: dragListener,
                      child: Flow(
                        delegate: flowDelegate,
                        children: voteTown.candidates
                            .map(
                              (c) => _CandidateWidget(
                                candidate: c,
                                primary: notification
                                        is! CandidateSetHoverNotification ||
                                    notification.relatedTo(c),
                                showCount: countForCandidate(c),
                              ),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: editor.removeCandidate,
                    child: const Text('Remove candidate'),
                  ),
                  OutlinedButton(
                    onPressed: editor.addCandidate,
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
  final bool primary;
  final int? showCount;
  const _CandidateWidget({
    Key? key,
    required this.candidate,
    required this.primary,
    required this.showCount,
  }) : super(key: key);

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
                  color:
                      primary ? candidate.color : candidate.color.withAlpha(51),
                  shape: const ContinuousRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(_candidateScale * 6)),
                  ),
                  shadows: primary
                      ? moving
                          ? _movingCandidateShadows
                          : _stationaryCandidateShadows
                      : null,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        candidate.id,
                        textScaleFactor: 1.5,
                        style: moving ? _movingWidgetTextStyle : null,
                      ),
                    ),
                    if (primary && showCount != null)
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            showCount!.toString(),
                            textScaleFactor: 0.7,
                          ),
                        ),
                      ),
                  ],
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
  final VoteNotification? _notification;

  _VoteTownPainter(this._voteTown, this._notification);

  @override
  void paint(Canvas canvas, Size size) {
    final offsetMultiplier = _offsetMultiplier(size);
    final radius = 2.5 * offsetMultiplier;

    for (var voter in _voteTown.voters) {
      canvas.drawCircle(
        Offset(voter.location.x, voter.location.y) * offsetMultiplier,
        radius,
        Paint()..color = _pick(voter.closestCandidates).darkColor,
      );
    }
  }

  TownCandidate _pick(Iterable<TownCandidate> candidates) {
    final notification = _notification;
    if (notification is CandidateSetHoverNotification) {
      return candidates.firstWhere(notification.relatedTo);
    }
    return candidates.first;
  }

  @override
  bool shouldRepaint(_VoteTownPainter oldDelegate) =>
      _voteTown != oldDelegate._voteTown ||
      _notification != oldDelegate._notification;
}
