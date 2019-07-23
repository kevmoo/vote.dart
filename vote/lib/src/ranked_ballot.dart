import 'package:meta/meta.dart';

import 'plurality_ballot.dart';
import 'util.dart';

@immutable
class RankedBallot<TCandidate> implements PluralityBallot<TCandidate> {
  @override
  TCandidate get choice => rank.first;

  final List<TCandidate> rank;

  RankedBallot(this.rank)
      : assert(rank != null),
        assert(rank.isNotEmpty),
        assert(allUnique(rank));

  @override
  Iterable<TCandidate> referencedCandidates() => rank;

  @override
  String toString() => '{RankedBallot for ${rank.length} candidates}';
}
