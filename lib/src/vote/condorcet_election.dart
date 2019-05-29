import 'package:graphs/graphs.dart';

import '../util.dart';
import 'condorcet_candidate_profile.dart';
import 'condorcet_pair.dart';
import 'election.dart';
import 'election_place.dart';
import 'ranked_ballot.dart';

class CondorcetElection<TVoter, TCandidate extends Comparable>
    extends Election<TVoter, TCandidate> {
  final Set<CondorcetPair> _pairs;
  final Map<TCandidate, CondorcetCandidateProfile> _profiles;

  @override
  final List<RankedBallot<TVoter, TCandidate>> ballots;

  @override
  final List<ElectionPlace<TCandidate>> places;

  CondorcetElection._internal(
      this._pairs, this._profiles, this.ballots, this.places);

  factory CondorcetElection(
      Iterable<RankedBallot<TVoter, TCandidate>> ballots) {
    final roBallots =
        List<RankedBallot<TVoter, TCandidate>>.unmodifiable(ballots);

    // Check voter uniqueness
    final voterList = List.unmodifiable(roBallots.map((b) => b.voter));
    requireArgument(
        allUnique(voterList), "Only one ballot per voter is allowed");

    var map = Map<CondorcetPair<TVoter, TCandidate>,
        List<RankedBallot<TVoter, TCandidate>>>();
    var candidateSet = Set<TCandidate>();

    for (final ballot in ballots) {
      for (var i = 0; i < ballot.rank.length; i++) {
        final candidateI = ballot.rank[i];
        candidateSet.add(candidateI);

        for (var j = i + 1; j < ballot.rank.length; j++) {
          final pair =
              CondorcetPair<TVoter, TCandidate>(candidateI, ballot.rank[j]);

          final pairBallotList = map.putIfAbsent(
              pair, () => List<RankedBallot<TVoter, TCandidate>>());
          pairBallotList.add(ballot);
        }
      }
    }

    var set = Set<CondorcetPair<TVoter, TCandidate>>();
    map.forEach((k, v) {
      var c = CondorcetPair<TVoter, TCandidate>(k.candidate1, k.candidate2, v);
      set.add(c);
    });

    var candidateProfiles =
        Map<TCandidate, CondorcetCandidateProfile<TCandidate>>();
    var tarjanMap = Map<TCandidate, Set<TCandidate>>();

    for (final candidate in candidateSet) {
      var lostTo = [];
      var beat = [];
      var tied = [];

      final tarjanLostTiedSet = Set<TCandidate>();

      for (final pair in set) {
        if (pair.candidate1 == candidate || pair.candidate2 == candidate) {
          final other = (pair.candidate1 == candidate)
              ? pair.candidate2
              : pair.candidate1;

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

      var profile = CondorcetCandidateProfile<TCandidate>(
          candidate,
          List.unmodifiable(lostTo),
          List.unmodifiable(beat),
          List.unmodifiable(tied));
      candidateProfiles[candidate] = profile;

      tarjanMap[candidate] = tarjanLostTiedSet;
    }

    var components = stronglyConnectedComponents<TCandidate>(
        tarjanMap.keys, (node) => tarjanMap[node]);

    var places = List<ElectionPlace<TCandidate>>();
    int placeNumber = 1;
    for (final round in components) {
      final place = ElectionPlace<TCandidate>(placeNumber, round);
      places.add(place);
      placeNumber += round.length;
    }

    return CondorcetElection._internal(
      set,
      candidateProfiles,
      roBallots,
      List.unmodifiable(places),
    );
  }

  @override
  Iterable<TCandidate> get candidates => _profiles.keys;

  CondorcetPair getPair(TCandidate c1, TCandidate c2) {
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
