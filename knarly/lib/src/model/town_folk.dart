import 'dart:math' as math;

import 'package:flutter_web_ui/ui.dart';

import 'candidate.dart';
import 'voter.dart';

class TownCandidate extends Candidate {
  static const candidateSpacing = 5.0;

  final Point location;

  final math.Point<int> intLocation;

  TownCandidate(int index, this.intLocation)
      : location = _unfixPoint(intLocation),
        super(index);

  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is TownCandidate && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TownCandidate($id)';
}

math.Point<int> fixPoint(Point value) => math.Point(
      (value.x / TownCandidate.candidateSpacing - 1).round(),
      (value.y / TownCandidate.candidateSpacing - 1).round(),
    );

Point _unfixPoint(math.Point<int> value) => Point(
      (value.x + 1) * TownCandidate.candidateSpacing,
      (value.y + 1) * TownCandidate.candidateSpacing,
    );

class TownVoter extends Voter {
  final Point location;
  final List<TownCandidate> closestCandidates;

  TownVoter(int id, this.location, this.closestCandidates) : super(id);
}
