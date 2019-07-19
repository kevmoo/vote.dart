import 'package:meta/meta.dart';

import 'election.dart';
import 'election_place.dart';
import 'irv_round.dart';
import 'ranked_ballot.dart';

@immutable
class IrvElection<TVoter, TCandidate extends Comparable>
    extends Election<TVoter, TCandidate, ElectionPlace<TCandidate>> {
  final List<IrvRound<TVoter, TCandidate>> rounds;

  IrvElection._internal(
    List<TCandidate> candidates,
    List<RankedBallot<TVoter, TCandidate>> ballots,
    List<ElectionPlace<TCandidate>> places,
    this.rounds,
  ) : super(
          candidates: candidates,
          ballots: ballots,
          places: places,
        );

  factory IrvElection(List<RankedBallot<TVoter, TCandidate>> ballots) {
    final candidates = ballots.expand((b) => b.rank).toSet();

    final rounds = <IrvRound<TVoter, TCandidate>>[];

    IrvRound<TVoter, TCandidate> round;
    final eliminatedCandidates = <TCandidate>{};
    do {
      round = IrvRound<TVoter, TCandidate>(
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

    final remaining = candidates.difference(candidatesInRounds);
    if (remaining.isNotEmpty) {
      places.add(ElectionPlace(
        places.last.place + places.last.length,
        remaining.toList(growable: false),
      ));
    }
    return IrvElection._internal(
      candidates.toList(growable: false),
      ballots,
      places,
      rounds,
    );
  }
}
