class IrvRound<TVoter extends Player, TCandidate extends Player> {
  // final HashMap<TCandidate, HashMap<TCandidate, num>> _eliminations;

  factory IrvRound(ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots,
    Enumerable<TCandidate> eliminatedCandidates) {

    final cleanedBallots = ballots.select((b) {
      return new Tuple(b, $(b.rank).exclude(eliminatedCandidates)
          .toReadOnlyCollection());
    });

    final candidateAllocations = cleanedBallots.group((tuple) {
      if(tuple.Item2.length == 0) {
        throw 'uh...um...figure out eliminted folks';
      } else {
        return tuple.Item2[0];
      }
    });

    candidateAllocations.forEach((k,v) {
      print(k);
      print(v.length);
    });

  }

}

/*
 * Factory
 * - ballots
 * - eliminated candidates
 *
 * Properties
 * - hasWinner
 * - ranked output (type?)
 * - eliminated candidates
 * - effective ballots? -> ballots after eliminated candidates
 *
 *
 *
 */
