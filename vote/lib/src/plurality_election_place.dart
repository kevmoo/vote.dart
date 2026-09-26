import 'package:meta/meta.dart';

import 'election_place.dart';

@immutable
class PluralityElectionPlace<TCandidate extends Comparable<Object>>(
  super.place,
  super.candidates,
  final int voteCount,
) extends ElectionPlace<TCandidate> {
  this : assert(voteCount >= 0);

  @override
  String toString() => 'Votes: $voteCount; ${super.toString()}';
}
