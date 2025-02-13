import 'package:meta/meta.dart';

import 'election_place.dart';

@immutable
class PluralityElectionPlace<TCandidate extends Comparable>
    extends ElectionPlace<TCandidate> {
  final int voteCount;

  PluralityElectionPlace(super.place, super.candidates, this.voteCount)
    : assert(voteCount >= 0);

  @override
  String toString() => 'Votes: $voteCount; ${super.toString()}';
}
