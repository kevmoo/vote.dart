import 'package:meta/meta.dart';

import 'ranked_ballot.dart';

@immutable
class IrvElimination<TVoter, TCandidate> {
  final TCandidate candidate;
  final Map<TCandidate, List<RankedBallot<TVoter, TCandidate>>> _transfers;
  final List<RankedBallot<TVoter, TCandidate>> exhausted;

  const IrvElimination(this.candidate, this._transfers, this.exhausted)
      : assert(candidate != null),
        assert(_transfers != null),
        assert(exhausted != null);

  Iterable<TCandidate> get transferredCandidates => _transfers.keys;

  int getTransferCount(TCandidate key) => _transfers[key]?.length ?? 0;
}
