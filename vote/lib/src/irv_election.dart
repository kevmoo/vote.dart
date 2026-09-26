import 'package:meta/meta.dart';

import 'election.dart';
import 'election_place.dart';
import 'irv_round.dart';
import 'ranked_ballot.dart';
import 'util.dart';

@immutable
class IrvElection<TCandidate extends Comparable<Object>>._internal(
  List<TCandidate> candidates,
  List<RankedBallot<TCandidate>> ballots,
  List<ElectionPlace<TCandidate>> places,
  final List<IrvRound<TCandidate>> rounds,
) extends Election<TCandidate, ElectionPlace<TCandidate>> {
  this : super(candidates: candidates, ballots: ballots, places: places);

  factory(
    List<RankedBallot<TCandidate>> ballots, {
    Iterable<TCandidate>? candidates,
  }) {
    final candidateSet = validateRankedBallotCandidates(ballots, candidates);

    final rounds = <IrvRound<TCandidate>>[];

    IrvRound<TCandidate> round;
    final eliminatedCandidates = <TCandidate>{};
    do {
      round = IrvRound<TCandidate>(
        rounds.length + 1,
        ballots,
        eliminatedCandidates,
      );
      rounds.add(round);
      eliminatedCandidates.addAll(round.eliminatedCandidates);
    } while (!round.isFinal);

    final candidatesInRounds = <TCandidate>{};
    final places = <ElectionPlace<TCandidate>>[];
    for (var round in rounds.reversed) {
      for (var roundPlace in round.places) {
        final copy = roundPlace.toList()
          ..removeWhere(places.expand((candidate) => candidate).contains);

        if (copy.isNotEmpty) {
          candidatesInRounds.addAll(copy);
          final place = places.isEmpty
              ? 1
              : places.last.place + places.last.length;
          places.add(ElectionPlace(place, copy));
        }
      }
    }

    final remaining = candidateSet.difference(candidatesInRounds);
    if (remaining.isNotEmpty) {
      places.add(
        ElectionPlace(
          places.last.place + places.last.length,
          remaining.toList(growable: false),
        ),
      );
    }
    return IrvElection._internal(
      candidateSet.toList(growable: false),
      ballots,
      places,
      rounds,
    );
  }
}
