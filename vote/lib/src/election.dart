import 'package:meta/meta.dart';

import 'ballot.dart';
import 'election_place.dart';
import 'util.dart';

abstract class Election<TCandidate extends Comparable,
    TElectionPlace extends ElectionPlace<TCandidate>> {
  Election({
    @required this.candidates,
    @required this.ballots,
    @required this.places,
  }) {
    // Waiting on https://github.com/dart-lang/linter/commit/767c3baaab02457a9c4
    // To land in an SDK
    // ignore: prefer_asserts_in_initializer_lists
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

    assert(placeCandidates.containsAll(allReferencedCandidates),
        ['', placeCandidates, allReferencedCandidates].join('\n'));
    assert(placeCandidates.containsAll(candidates),
        ['', placeCandidates, candidates].join('\n'));
    return true;
  }

  final List<TCandidate> candidates;

  final List<Ballot<TCandidate>> ballots;

  final List<TElectionPlace> places;

  bool get hasSingleWinner => places.isNotEmpty && places.first.length == 1;

  TCandidate get singleWinner {
    if (hasSingleWinner) {
      return places.first.first;
    } else {
      return null;
    }
  }
}
