import 'condorcet_candidate_profile.dart';
import 'condorcet_pair.dart';
import 'election.dart';
import 'election_place.dart';
import 'ranked_ballot.dart';

import '../util.dart';

class CondorcetElection extends Election {
  final Set<CondorcetPair> _pairs;
  final Map<Comparable, CondorcetCandidateProfile> _profiles;

  @override
  final List<RankedBallot> ballots;

  @override
  final List<ElectionPlace<Comparable>> places;

  CondorcetElection._internal(
      this._pairs, this._profiles, this.ballots, this.places);

  factory CondorcetElection(
      Iterable<RankedBallot<Comparable, Comparable>> ballots) {
    final roBallots = new List<RankedBallot>.unmodifiable(ballots);

    // Check voter uniqueness
    final voterList = new List.unmodifiable(roBallots.map((b) => b.voter));
    requireArgument(
        allUnique(voterList), "Only one ballot per voter is allowed");

    var map =
        new Map<CondorcetPair, List<RankedBallot<Comparable, Comparable>>>();
    var candidateSet = new Set();

    for (final ballot in ballots) {
      for (var i = 0; i < ballot.rank.length; i++) {
        final candidateI = ballot.rank[i];
        candidateSet.add(candidateI);

        for (var j = i + 1; j < ballot.rank.length; j++) {
          final pair = new CondorcetPair<Comparable, Comparable>(
              candidateI, ballot.rank[j]);

          final pairBallotList = map.putIfAbsent(
              pair, () => new List<RankedBallot<Comparable, Comparable>>());
          pairBallotList.add(ballot);
        }
      }
    }

    var set = new Set<CondorcetPair>();
    map.forEach((k, v) {
      var c = new CondorcetPair<Comparable, Comparable>(k.item1, k.item2, v);
      set.add(c);
    });

    var candidateProfiles = new Map<Comparable, CondorcetCandidateProfile>();
    var tarjanMap = new Map<dynamic, Set<dynamic>>();

    for (final candidate in candidateSet) {
      var lostTo = [];
      var beat = [];
      var tied = [];

      final tarjanLostTiedSet = new Set();

      for (final pair in set) {
        if (pair.item1 == candidate || pair.item2 == candidate) {
          final other = (pair.item1 == candidate) ? pair.item2 : pair.item1;

          if (pair.isTie) {
            tied.add(other);
            tarjanLostTiedSet.add(other);
          } else if (pair.winner == candidate) {
            beat.add(other);
          } else {
            assert(pair.winner == other);
            lostTo.add(other);
            tarjanLostTiedSet.add(other);
          }
        }
      }

      var profile = new CondorcetCandidateProfile<Comparable>(
          candidate,
          new List.unmodifiable(lostTo),
          new List.unmodifiable(beat),
          new List.unmodifiable(tied));
      candidateProfiles[candidate] = profile;

      tarjanMap[candidate] = tarjanLostTiedSet;
    }

    var components = stronglyConnectedComponents(tarjanMap);

    var places = new List<ElectionPlace>();
    int placeNumber = 1;
    for (final round in components) {
      final place = new ElectionPlace(placeNumber, round);
      places.add(place);
      placeNumber += round.length;
    }

    return new CondorcetElection._internal(set, candidateProfiles, roBallots,
        new List<ElectionPlace>.unmodifiable(places));
  }

  @override
  Iterable<Comparable> get candidates => _profiles.keys;

  CondorcetPair getPair(c1, c2) {
    var filter = _pairs.where((p) => p.matches(c1, c2));
    assert(filter.length <= 1);
    if (filter.isEmpty) {
      return null;
    } else {
      assert(filter.length == 1);
      return filter.first.flip(c1, c2);
    }
  }
}
