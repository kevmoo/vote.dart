import 'package:meta/meta.dart';

import 'election.dart';
import 'election_place.dart';
import 'irv_round.dart';
import 'ranked_ballot.dart';

@immutable
class IrvElection<TCandidate extends Comparable>
    extends Election<TCandidate, ElectionPlace<TCandidate>> {
  final List<IrvRound<TCandidate>> rounds;

  IrvElection._internal(
    List<TCandidate> candidates,
    List<RankedBallot<TCandidate>> ballots,
    List<ElectionPlace<TCandidate>> places,
    this.rounds,
  ) : super(
          candidates: candidates,
          ballots: ballots,
          places: places,
        );

  factory IrvElection(
    List<RankedBallot<TCandidate>> ballots, {
    Iterable<TCandidate>? candidates,
  }) {
    final ballotCandidates = ballots.expand((b) => b.rank).toSet();

    final candidateSet =
        candidates == null ? ballotCandidates : candidates.toSet();

    assert(
      candidates == null || candidateSet.containsAll(ballotCandidates),
      'If `candidates` is provided, then every candidate in `ballots` should '
      'exist in `candidates`.',
    );

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
          final place =
              places.isEmpty ? 1 : places.last.place + places.last.length;
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
