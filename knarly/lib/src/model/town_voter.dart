import 'package:flutter_web_ui/ui.dart';

import 'town_candidate.dart';

class TownVoter implements Comparable<TownVoter> {
  final int id;

  final Point location;
  final List<TownCandidate> closestCandidates;

  TownVoter(this.id, this.location, this.closestCandidates) : assert(id >= 0);

  @override
  int compareTo(TownVoter other) => id.compareTo(other.id);

  @override
  bool operator ==(other) => other is TownVoter && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
