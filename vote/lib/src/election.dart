import 'ballot.dart';
import 'election_place.dart';
import 'util.dart';

/// Baseclass of all election types.
abstract class Election<
  TCandidate extends Comparable<dynamic>,
  TElectionPlace extends ElectionPlace<TCandidate>
>({
  required super.candidates,

  /// All of the ballots cast in the election.
  required final List<Ballot<TCandidate>> ballots,
  required super.places,
}) extends ElectionResult<TCandidate, TElectionPlace> {
  this : super._noAssert() {
    assert(_assert(ballots: ballots));
  }
}

/// The baseclass for the results of an [Election].
///
/// Implementations may not include ballot information, to protect the privacy
/// of ballots – or just to allow visualization of an election result.
abstract class ElectionResult<
  TCandidate extends Comparable<dynamic>,
  TElectionPlace extends ElectionPlace<TCandidate>
> {
  new({required this.candidates, required this.places}) {
    assert(_assert());
  }

  new _noAssert({required this.candidates, required this.places});

  bool _assert({List<Ballot<TCandidate>>? ballots}) {
    // TODO: assert all candidates are sorted, too?
    assert(candidates.allUnique);

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

    if (ballots != null) {
      final allReferencedCandidates = ballots
          .expand((b) => b.referencedCandidates())
          .toSet();

      assert(allReferencedCandidates.every(candidates.contains));

      assert(
        placeCandidates.containsAll(allReferencedCandidates),
        ['', placeCandidates, allReferencedCandidates].join('\n'),
      );
    }
    assert(
      placeCandidates.containsAll(candidates),
      ['', placeCandidates, candidates].join('\n'),
    );
    return true;
  }

  /// All of the candidates in the election.
  final List<TCandidate> candidates;

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
