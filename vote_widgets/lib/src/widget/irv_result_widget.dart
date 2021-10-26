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

class IrvResultWidget<TCandidate extends Candidate> extends StatelessWidget {
  const IrvResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<IrvElection<TCandidate>>(
        builder: (context, irvElection, __) => Table(
          // Work around for https://github.com/flutter/flutter/issues/91068
          // Change the key when the candidate length changes – seems to help
          key: ValueKey('Table bug key ${irvElection.candidates.length}'),
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
    List<_Data>? lastRoundData;
    for (var round in election.rounds) {
      final roundData = [
        for (var i = 0; i < round.places.length; i++)
          for (var candidate in round.places[i])
            _Data(
              round.places[i].place,
              round.places[i],
              candidate,
            ),
      ];

      List<Widget> createFillers() => List<Widget>.generate(
            election.candidates.length - roundData.length,
            (_) => const SizedBox(),
          );

      // Only output place numbers on the first round and follow-up rounds
      // if the place data changes.
      if (lastRoundData == null ||
          !_dataIterableEquals(
            roundData,
            lastRoundData.take(roundData.length),
          )) {
        // places
        yield <Widget>[
          const SizedBox(),
          for (var item in roundData)
            PaddedText.bits(
              background: Colors.grey.shade100,
              text: item.placeNumber.toString(),
              fontWeight: FontWeight.w600,
            ),
          ...createFillers(),
        ];
      }

      lastRoundData = roundData;

      // candidates
      yield <Widget>[
        const SizedBox(),
        for (var item in roundData)
          PaddedText(
            text: item.candidate.id,
            background: item.candidate.color,
            style:
                (round.isFinal && item.place.topPlace) ? winnerTextStyle : null,
          ),
        ...createFillers(),
      ];

      // vote count
      yield <Widget>[
        CandidateHoverWidget<TCandidate>(
          candidates: roundData.map((e) => e.candidate).toSet(),
          child: PaddedText(
            text: 'Round ${round.number}',
            style: round.isFinal ? winnerTextStyle : null,
          ),
        ),
        for (var item in roundData)
          PaddedText(
            text: item.place.voteCount.toString(),
            background: item.candidate.color,
            style: (round.isFinal && item.place.topPlace)
                ? winnerTextStyle
                : round.eliminationForCandidate(item.candidate) == null
                    ? null
                    : const TextStyle(fontStyle: FontStyle.italic),
          ),
        ...createFillers(),
      ];

      // eliminations
      for (var elimination in round.eliminations) {
        Widget eliminationContent(TCandidate candidate) {
          if (candidate == elimination.candidate) {
            final content =
                elimination.transferredCandidates.isEmpty ? '×' : '↵';
            return PaddedText(
              text: content,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'OverpassMono',
              ),
            );
          }

          final count = elimination.getTransferCount(candidate);
          if (count == 0) {
            return const SizedBox();
          }
          return PaddedText(text: count.toString());
        }

        yield <Widget>[
          PaddedText.bits(
            text: elimination.candidate.id,
            tooltip: 'Candidate ${elimination.candidate.id} eliminated.\n'
                'Votes redistributed.',
            textAlign: TextAlign.right,
            fontStyle: FontStyle.italic,
          ),
          for (var item in roundData) eliminationContent(item.candidate),
          ...createFillers(),
        ];
      }
    }
  }
}

bool _dataIterableEquals(Iterable<_Data> a, Iterable<_Data> b) =>
    const IterableEquality<_Data>().equals(a, b);

class _Data<TCandidate extends Candidate> {
  final int placeNumber;
  final TCandidate candidate;
  final PluralityElectionPlace<TCandidate> place;

  _Data(
    this.placeNumber,
    this.place,
    this.candidate,
  );

  @override
  bool operator ==(Object other) =>
      other is _Data &&
      placeNumber == other.placeNumber &&
      candidate == other.candidate;

  @override
  int get hashCode => Object.hash(placeNumber, candidate);
}
