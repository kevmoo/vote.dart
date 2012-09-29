class IrvRound<TVoter extends Player, TCandidate extends Player> {
  final ReadOnlyCollection<PluralityElectionPlace<TCandidate>> places;
  // final HashMap<TCandidate, HashMap<TCandidate, num>> _eliminations;

  factory IrvRound(ReadOnlyCollection<RankedBallot<TVoter, TCandidate>> ballots,
    Enumerable<TCandidate> eliminatedCandidates) {

    final cleanedBallots = ballots.map((b) {
      final pruned = $(b.rank).exclude(eliminatedCandidates)
          .toReadOnlyCollection();
      final winner = pruned.length == 0 ?
          null : pruned[0];
      return new Tuple3(b, pruned, winner);
    });

    final activeBallotCount = cleanedBallots.count((t) => t.item3 != null);

    final candidateAllocations = cleanedBallots.group((tuple) => tuple.item3);

    final voteGroups = $(candidateAllocations.getKeys()).group((c) {
      return candidateAllocations[c].length;
    });

    final placeVotes = $(voteGroups.getKeys()).toList();
    // reverse sorting -> most votes first
    placeVotes.sort((a,b) => b.compareTo(a));

    int placeNumber = 1;
    int totalVotes = 0;
    final places = $(placeVotes).map((pv) {
      final vg = voteGroups[pv];
      final currentPlaceNumber = placeNumber;
      totalVotes += vg.length * pv;
      placeNumber += vg.length;
      return new PluralityElectionPlace<TCandidate>(currentPlaceNumber, vg, pv);
    }).toReadOnlyCollection();

    //
    // eliminations
    //
    // 2 or more 'places'
    // unless
    // a) first place is single candiadate
    // b) first place votes > (0.5 * total + 1)

    return new IrvRound._internal(places);
  }

  IrvRound._internal(this.places);
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
