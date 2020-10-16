import 'package:meta/meta.dart';

import 'ranked_ballot.dart';

@immutable
class IrvElimination<TCandidate extends Comparable> {
  final TCandidate candidate;
  final Map<TCandidate, List<RankedBallot<TCandidate>>> _transfers;
  final List<RankedBallot<TCandidate>> exhausted;

  const IrvElimination(this.candidate, this._transfers, this.exhausted);

  Iterable<TCandidate> get transferredCandidates => _transfers.keys;

  int getTransferCount(TCandidate key) => _transfers[key]?.length ?? 0;
}
