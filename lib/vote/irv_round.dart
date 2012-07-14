class IrvRound<TVoter extends Player, TCandidate extends Player> {
  // final HashMap<TCandidate, HashMap<TCandidate, num>> _eliminations;

  factory IrvRound(ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots,
    Enumerable<TCandidate> eliminatedCandidates) {

    final cleanedBallots = ballots.select((b) {
      final pruned = $(b.rank).exclude(eliminatedCandidates)
          .toReadOnlyCollection();
      final winner = pruned.length == 0 ?
          null : pruned[0];
      return new Tuple3(b, pruned, winner);
    });

    final candidateAllocations = cleanedBallots.group((tuple) => tuple.Item3);

    final voteGroups = $(candidateAllocations.getKeys()).group((c) {
      return candidateAllocations[c].length;
    });

    final placeVotes = $(voteGroups.getKeys()).toList();
    // reverse sorting -> most votes first
    placeVotes.sort((a,b) => b.compareTo(a));
    print(placeVotes);

    int totalVotes = 0;
    candidateAllocations.forEach((k,v) {
      assert(v != null);
      assert(v.length > 0);
      totalVotes += v.length;
    });

    print(totalVotes);
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
