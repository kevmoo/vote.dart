import 'election_place.dart';

class PluralityElectionPlace<TCandidate extends Comparable>
    extends ElectionPlace<TCandidate> {
  final int voteCount;

  PluralityElectionPlace(
      int place, Iterable<TCandidate> candidates, this.voteCount)
      : super(place, candidates) {
    assert(voteCount >= 0);
  }

  @override
  String toString() {
    return 'Votes: $voteCount; ${super.toString()}';
  }
}
