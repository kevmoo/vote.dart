import 'dart:math';
import 'dart:ui';

import 'package:vote_widgets/helpers.dart';
import 'package:vote_widgets/vote_widgets.dart';

import 'voter.dart';

class TownCandidate(final int index, double hue, final Point<int> intLocation)
    extends Candidate {
  static const candidateSpacing = 5.0;

  final Point<double> location = _unfixPoint(intLocation);

  this
    : assert(index >= 0),
      assert(index < maxCandidateCount),
      super(String.fromCharCode(index + _capitalACharCode), hue);

  factory letter(int index, Point<int> intLocation) =>
      TownCandidate(index, candidateHues[index], intLocation);

  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(Object other) => other is TownCandidate && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

Point<int> fixPoint(Offset value) => Point(
  (value.dx / TownCandidate.candidateSpacing - 1).round(),
  (value.dy / TownCandidate.candidateSpacing - 1).round(),
);

Point<double> _unfixPoint(Point<int> value) => Point(
  (value.x + 1) * TownCandidate.candidateSpacing,
  (value.y + 1) * TownCandidate.candidateSpacing,
);

class TownVoter(
  super.id,
  final Point<double> location,
  final List<TownCandidate> closestCandidates,
) extends Voter;

const _capitalACharCode = 65;
