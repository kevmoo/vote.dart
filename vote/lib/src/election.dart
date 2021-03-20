import 'ballot.dart';
import 'election_place.dart';
import 'util.dart';

/// Baseclass of all election types.
abstract class Election<TCandidate extends Comparable,
    TElectionPlace extends ElectionPlace<TCandidate>> {
  Election({
    required this.candidates,
    required this.ballots,
    required this.places,
  }) {
    assert(_assert());
  }

  bool _assert() {
    // TODO: assert all candidates are sorted, too?
    assert(allUnique(candidates));

    final allReferencedCandidates =
        ballots.expand((b) => b.referencedCandidates()).toSet();

    assert(allReferencedCandidates.every(candidates.contains));

    final placeCandidates = <TCandidate>{};

    for (var i = 0; i < places.length; i++) {
      final place = places[i];
      if (i == 0) {
        assert(place.place == 1);
      } else {
        final previousPlace = places[i - 1];
        assert(
          place.place == previousPlace.place + previousPlace.length,
          'Places should be ordered and numbered correctly',
        );
      }
      for (var candidate in place) {
        assert(
          placeCandidates.add(candidate),
          'Should only see $candidate once',
        );
      }
    }

    assert(
      placeCandidates.containsAll(allReferencedCandidates),
      ['', placeCandidates, allReferencedCandidates].join('\n'),
    );
    assert(
      placeCandidates.containsAll(candidates),
      ['', placeCandidates, candidates].join('\n'),
    );
    return true;
  }

  /// All of the candidates in the election.
  final List<TCandidate> candidates;

  /// All of the ballots cast in the election.
  final List<Ballot<TCandidate>> ballots;

  /// The ordered result of the election.
  final List<TElectionPlace> places;

  /// Returns `true` if there is a single winner in the election
  /// (there is no tie).
  bool get hasSingleWinner => places.isNotEmpty && places.first.length == 1;

  /// If [hasSingleWinner] is `true`, returns the corresponding candidate.
  ///
  /// Otherwise, `null`.
  TCandidate? get singleWinner {
    if (hasSingleWinner) {
      return places.first.first;
    } else {
      return null;
    }
  }
}
