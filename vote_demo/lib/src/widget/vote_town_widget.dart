import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_widgets/vote_widgets.dart';

import '../model/strategic_simulator.dart';
import '../model/town_folk.dart';
import '../model/vote_town.dart';
import '../view_model/vote_town_editor.dart';

class const VoteTownWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<VoteTownEditor>(
    builder: (_, editor, _) {
      final voteTown = editor.value;

      final flowDelegate = _CandidateFlowDelegate(voteTown);

      bool dragListener(_CandidateDragNotification notification) {
        final details = notification.details;

        if (details is DragStartDetails) {
          editor.moveCandidateStart(notification.candidate);
        } else if (details is DragUpdateDetails) {
          final scale = 1 / _offsetMultiplier(flowDelegate._drawSize);
          final newValue = details.delta * scale;

          editor.moveCandidateUpdate(notification.candidate, newValue);
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
          Consumer<VoteNotification<dynamic>?>(
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
                            primary:
                                notification
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
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              OutlinedButton(
                onPressed: editor.removeCandidate,
                child: const Text('Remove candidate'),
              ),
              OutlinedButton(
                onPressed: editor.addCandidate,
                child: const Text('Add candidate'),
              ),
              OutlinedButton.icon(
                onPressed: editor.scatterCandidates,
                icon: const Icon(Icons.shuffle, size: 16),
                label: const Text('Scatter'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Presets:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              for (final preset in VoteTownPreset.values)
                Tooltip(
                  message: preset.description,
                  child: ActionChip(
                    label: Text(
                      preset.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => editor.applyPreset(preset),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _StrategicSimulationControls(editor: editor),
        ],
      );
    },
  );
}

class const _StrategicSimulationControls({required final VoteTownEditor editor})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nextCandidate = editor.nextCandidate;
    final candidates = editor.value.candidates;
    final moleCandidate =
        editor.simulationMode.hasMole && candidates.length >= 2
        ? candidates.last
        : null;

    final modeCaption = switch (editor.simulationMode) {
      SimulationMode.selfish => editor.simulationMode.shortDescription,
      SimulationMode.moleHelpsA =>
        moleCandidate != null
            ? 'Candidate ${moleCandidate.id} (+A) is a Mole trying to help A '
                  'win.'
            : editor.simulationMode.shortDescription,
      SimulationMode.moleHurtsA =>
        moleCandidate != null
            ? 'Candidate ${moleCandidate.id} (−A) is a Mole trying to make A '
                  'lose.'
            : editor.simulationMode.shortDescription,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Strategic Candidate Simulation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (nextCandidate != null)
                Text(
                  'Next turn: ${nextCandidate.id}'
                  '${editor.isMole(nextCandidate) ? " (Mole)" : ""}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(
                width: 64,
                child: Text(
                  'Method:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: SegmentedButton<TargetElectionMethod>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  segments: [
                    for (final method in TargetElectionMethod.values)
                      ButtonSegment<TargetElectionMethod>(
                        value: method,
                        label: Text(
                          method.label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                  selected: {editor.targetMethod},
                  onSelectionChanged: (selected) =>
                      editor.targetMethod = selected.first,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const SizedBox(
                width: 64,
                child: Text(
                  'Agents:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: SegmentedButton<SimulationMode>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  segments: [
                    for (final mode in SimulationMode.values)
                      ButtonSegment<SimulationMode>(
                        value: mode,
                        label: Text(
                          mode.label,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                  selected: {editor.simulationMode},
                  onSelectionChanged: (selected) =>
                      editor.simulationMode = selected.first,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            modeCaption,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: editor.isSimulating ? null : editor.stepSimulation,
                icon: const Icon(Icons.skip_next, size: 18),
                label: Text(
                  nextCandidate == null ? 'Step' : 'Step (${nextCandidate.id})',
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: editor.toggleSimulation,
                icon: Icon(
                  editor.isSimulating ? Icons.pause : Icons.play_arrow,
                  size: 18,
                ),
                label: Text(editor.isSimulating ? 'Pause' : 'Play'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _candidateScale = 4.7;

class const _CandidateDragNotification(
  final TownCandidate candidate,
  final Object details,
) extends Notification;

class const _CandidateWidget({
  required final TownCandidate candidate,
  required final bool primary,
  required final int? showCount,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<VoteTownEditor>(
    builder: (context, model, _) {
      void handler(Object details) =>
          _CandidateDragNotification(candidate, details).dispatch(context);

      final moving = candidate == model.movingCandidate;
      final lastMoved = candidate == model.lastMovedCandidate;
      final moleBadge = model.moleBadgeFor(candidate);

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onPanStart: handler,
          onPanUpdate: handler,
          onPanEnd: handler,
          child: Container(
            decoration: ShapeDecoration(
              color: primary ? candidate.color : candidate.color.withAlpha(51),
              shape: ContinuousRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(_candidateScale * 6),
                ),
                side: moleBadge != null
                    ? const BorderSide(width: 2)
                    : lastMoved
                    ? const BorderSide(color: Colors.black54, width: 1.5)
                    : BorderSide.none,
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
                    textScaler: const TextScaler.linear(1.4),
                    style: moving || lastMoved ? _movingWidgetTextStyle : null,
                  ),
                ),
                if (primary && moleBadge != null)
                  Positioned(
                    top: 1,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        moleBadge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (primary && showCount != null)
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        showCount!.toString(),
                        textScaler: const TextScaler.linear(0.7),
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
    BoxShadow(offset: Offset(-1, 1), blurRadius: 2),
  ];

  static const _movingCandidateShadows = [
    BoxShadow(offset: Offset(-2, 2), blurRadius: 2),
  ];

  static const _movingWidgetTextStyle = TextStyle(fontWeight: FontWeight.bold);
}

double _offsetMultiplier(Size size) =>
    math.min(size.height, size.width) /
    (VoteTown.votersAcross * VoteTown.voterSpacing);

class _CandidateFlowDelegate(final VoteTown _voteTown) extends FlowDelegate {
  Size _drawSize = Size.zero;
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

class _VoteTownPainter(
  final VoteTown _voteTown,
  final VoteNotification<dynamic>? _notification,
) extends CustomPainter {
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
