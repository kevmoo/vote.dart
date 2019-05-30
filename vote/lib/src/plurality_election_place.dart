import 'package:meta/meta.dart';

import 'election_place.dart';

@immutable
class PluralityElectionPlace<TCandidate extends Comparable>
    extends ElectionPlace<TCandidate> {
  final int voteCount;

  PluralityElectionPlace(int place, List<TCandidate> candidates, this.voteCount)
      : assert(voteCount >= 0),
        super(place, candidates);

  @override
  String toString() => 'Votes: $voteCount; ${super.toString()}';
}
