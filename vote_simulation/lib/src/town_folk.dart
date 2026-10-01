import 'dart:math';

import 'candidate.dart';
import 'voter.dart';

class TownCandidate(final int index, double hue, final Point<double> location)
    extends Candidate {
  static const candidateSpacing = 5.0;
  static const minSeparation = 17.5;
  static const repulsionRadius = 29.0;
  static const boardMargin = 6.5;

  this
    : assert(index >= 0),
      assert(index < maxCandidateCount),
      super(String.fromCharCode(index + _capitalACharCode), hue);

  factory letter(int index, Point<double> location) =>
      TownCandidate(index, candidateHues[index], location);

  TownCandidate withLocation(Point<double> newLocation) =>
      TownCandidate(index, hue, newLocation);

  @override
  int compareTo(Candidate other) => id.compareTo(other.id);

  @override
  bool operator ==(Object other) => other is TownCandidate && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class TownVoter(
  super.id,
  final Point<double> location,
  final List<TownCandidate> closestCandidates,
) extends Voter;

const _capitalACharCode = 65;
