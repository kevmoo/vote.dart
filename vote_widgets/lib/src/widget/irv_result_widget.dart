import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../../helpers.dart';
import '../model/candidate.dart';
import 'utility_widgets.dart';
import 'vote_hover.dart';

// TODO: display candidates that don't even make the first round
// TODO: flip transfer rounds

class const IrvResultWidget<TCandidate extends Candidate>()
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<IrvElection<TCandidate>>(
    builder: (context, irvElection, _) => Table(
      columnWidths: {
        0: const FlexColumnWidth(2),
        for (var i = 0; i < irvElection.candidates.length; i++)
          i + 1: const FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _rowsForElection(irvElection)
          .map((list) => TableRow(children: list))
          .toList(growable: false),
    ),
  );

  Iterable<List<Widget>> _rowsForElection(
    IrvElection<TCandidate> election,
  ) sync* {
    List<_Data<TCandidate>>? lastRoundData;
    for (final round in election.rounds) {
      final roundData = _roundDataFor(round);

      // Only output place numbers on the first round and follow-up rounds
      // if the place data changes.
      if (lastRoundData == null ||
          !_dataIterableEquals(
            roundData,
            lastRoundData.take(roundData.length),
          )) {
        yield _buildPlacesRow(roundData, election.candidates.length);
      }

      lastRoundData = roundData;

      yield _buildCandidatesRow(round, roundData, election.candidates.length);
      yield _buildVoteCountRow(round, roundData, election.candidates.length);

      for (final elimination in round.eliminations) {
        yield _buildEliminationRow(
          elimination,
          roundData,
          election.candidates.length,
        );
      }
    }
  }
}

/// Flattens the candidate place entries of [round] into an ordered list of
/// [_Data].
List<_Data<TCandidate>> _roundDataFor<TCandidate extends Candidate>(
  IrvRound<TCandidate> round,
) => [
  for (final place in round.places)
    for (final candidate in place) _Data(place.place, place, candidate),
];

/// Generates empty [SizedBox] filler widgets to pad row widths for eliminated
/// candidates.
List<Widget> _createFillers(int candidateCount, int roundDataCount) =>
    List<Widget>.generate(
      candidateCount - roundDataCount,
      (_) => const SizedBox(),
    );

/// Builds the table row containing place number header indicators for active
/// candidates.
List<Widget> _buildPlacesRow<TCandidate extends Candidate>(
  List<_Data<TCandidate>> roundData,
  int candidateCount,
) => [
  const SizedBox(),
  for (final item in roundData)
    PaddedText.bits(
      background: Colors.grey.shade100,
      text: item.placeNumber.toString(),
      fontWeight: FontWeight.w600,
    ),
  ..._createFillers(candidateCount, roundData.length),
];

/// Builds the table row displaying candidate ID labels and their theme colors.
List<Widget> _buildCandidatesRow<TCandidate extends Candidate>(
  IrvRound<TCandidate> round,
  List<_Data<TCandidate>> roundData,
  int candidateCount,
) => [
  const SizedBox(),
  for (final item in roundData)
    PaddedText(
      text: item.candidate.id,
      background: item.candidate.color,
      style: (round.isFinal && item.place.topPlace) ? winnerTextStyle : null,
    ),
  ..._createFillers(candidateCount, roundData.length),
];

/// Builds the table row displaying the round number and current vote tallies.
List<Widget> _buildVoteCountRow<TCandidate extends Candidate>(
  IrvRound<TCandidate> round,
  List<_Data<TCandidate>> roundData,
  int candidateCount,
) => [
  CandidateHoverWidget<TCandidate>(
    candidates: roundData.map((e) => e.candidate).toSet(),
    child: PaddedText(
      text: 'Round ${round.number}',
      style: round.isFinal ? winnerTextStyle : null,
    ),
  ),
  for (final item in roundData)
    PaddedText(
      text: item.place.voteCount.toString(),
      background: item.candidate.color,
      style: (round.isFinal && item.place.topPlace)
          ? winnerTextStyle
          : round.eliminationForCandidate(item.candidate) == null
          ? null
          : const TextStyle(fontStyle: FontStyle.italic),
    ),
  ..._createFillers(candidateCount, roundData.length),
];

/// Renders the elimination indicator icon or vote transfer count cell for
/// [candidate].
Widget _eliminationContent<TCandidate extends Candidate>(
  IrvElimination<TCandidate> elimination,
  TCandidate candidate,
) {
  if (candidate == elimination.candidate) {
    final icon = elimination.transferredCandidates.isEmpty
        ? Icons.close
        : Icons.subdirectory_arrow_left;
    return Icon(icon);
  }

  final count = elimination.getTransferCount(candidate);
  if (count == 0) {
    return const SizedBox();
  }
  return PaddedText(text: count.toString());
}

/// Builds the table row displaying vote transfer distributions from an
/// eliminated candidate.
List<Widget> _buildEliminationRow<TCandidate extends Candidate>(
  IrvElimination<TCandidate> elimination,
  List<_Data<TCandidate>> roundData,
  int candidateCount,
) => [
  PaddedText.bits(
    text: elimination.candidate.id,
    tooltip:
        'Candidate ${elimination.candidate.id} eliminated.\n'
        'Votes redistributed.',
    textAlign: TextAlign.right,
    fontStyle: FontStyle.italic,
  ),
  for (final item in roundData)
    _eliminationContent(elimination, item.candidate),
  ..._createFillers(candidateCount, roundData.length),
];

bool _dataIterableEquals(Iterable<_Data> a, Iterable<_Data> b) =>
    const IterableEquality<_Data>().equals(a, b);

class _Data<TCandidate extends Candidate>(
  final int placeNumber,
  final PluralityElectionPlace<TCandidate> place,
  final TCandidate candidate,
) {
  @override
  bool operator ==(Object other) =>
      other is _Data &&
      placeNumber == other.placeNumber &&
      candidate == other.candidate;

  @override
  int get hashCode => Object.hash(placeNumber, candidate);
}
