import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../model/candidate.dart';
import 'utility_widgets.dart';

// TODO: display candidates that don't even make the first round
// TODO: flip transfer rounds

class RankedChoiceElectionResultWidget extends StatelessWidget {
  const RankedChoiceElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<IrvElection<Candidate>>(
        builder: (context, irvElection, __) => Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _updateElement(irvElection)
              .map((list) => TableRow(children: list))
              .toList(growable: false),
        ),
      );

  Iterable<List<Widget>> _updateElement(
    IrvElection<Candidate> election,
  ) sync* {
    List<_Data>? lastRoundData;
    for (var round in election.rounds) {
      final roundData = [
        for (var i = 0; i < round.places.length; i++)
          for (var candidate in round.places[i])
            _Data(
              i + 1,
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
              roundData, lastRoundData.take(roundData.length))) {
        // places
        yield <Widget>[
          const SizedBox(),
          for (var item in roundData)
            PaddedText.bits(
              text: item.placeNumber.toString(),
            ),
          ...createFillers(),
        ];
      }

      lastRoundData = roundData;

      // candidates
      yield <Widget>[
        const SizedBox(),
        for (var item in roundData)
          PaddedText.bits(
            text: item.candidate.id,
            background: item.candidate.color,
          ),
        ...createFillers(),
      ];

      // vote count
      yield <Widget>[
        PaddedText.bits(
          text: 'Round ${round.number}',
        ),
        for (var item in roundData)
          PaddedText.bits(
            text: item.place.voteCount.toString(),
            background: item.candidate.color,
            fontStyle: round.eliminationForCandidate(item.candidate) == null
                ? null
                : FontStyle.italic,
          ),
        ...createFillers(),
      ];

      // eliminations
      for (var elimination in round.eliminations) {
        Widget eliminationContent(Candidate candidate) {
          if (candidate == elimination.candidate) {
            final content =
                elimination.transferredCandidates.isEmpty ? '×' : '←';
            return PaddedText(text: content);
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

class _Data {
  final int placeNumber;
  final Candidate candidate;
  final PluralityElectionPlace<Candidate> place;

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
  int get hashCode => placeNumber ^ 7 * candidate.hashCode;
}
