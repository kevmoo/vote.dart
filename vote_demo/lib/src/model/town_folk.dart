import 'dart:math';
import 'dart:ui';

import 'package:vote_widgets/helpers.dart';
import 'package:vote_widgets/vote_widgets.dart';

import 'voter.dart';

class TownCandidate extends Candidate {
  static const candidateSpacing = 5.0;

  final Point<double> location;

  final Point<int> intLocation;

  final int index;

  TownCandidate(this.index, double hue, this.intLocation)
      : location = _unfixPoint(intLocation),
        assert(index >= 0),
        assert(index < maxCandidateCount),
        super(String.fromCharCode(index + _capitalACharCode), hue);

  factory TownCandidate.letter(int index, Point<int> intLocation) =>
      TownCandidate(
        index,
        candidateHues[index],
        intLocation,
      );

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

class TownVoter extends Voter {
  final Point<double> location;
  final List<TownCandidate> closestCandidates;

  TownVoter(int id, this.location, this.closestCandidates) : super(id);
}

const _capitalACharCode = 65;
