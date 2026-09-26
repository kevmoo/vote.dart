import 'package:meta/meta.dart';

import 'ranked_ballot.dart';

@immutable
class const IrvElimination<TCandidate extends Comparable<dynamic>>(
  final TCandidate candidate,
  final Map<TCandidate, List<RankedBallot<TCandidate>>> _transfers,
  final List<RankedBallot<TCandidate>> exhausted,
) {
  Iterable<TCandidate> get transferredCandidates => _transfers.keys;

  int getTransferCount(TCandidate key) => _transfers[key]?.length ?? 0;
}
