import 'package:collection/collection.dart';
import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../model/town_candidate.dart';
import '../model/town_voter.dart';
import '../vote_town_notifier.dart';

class RankedChoiceElectionResultWidget extends StatelessWidget {
  const RankedChoiceElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTownNotifier>(
        builder: (context, notifier, __) => Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _updateElement(notifier.value.irvElection)
              .map((list) => TableRow(children: list))
              .toList(growable: false),
        ),
      );

  Iterable<List<Widget>> _updateElement(
    IrvElection<TownVoter, TownCandidate> election,
  ) sync* {
    List<Widget> items;

    void fillItems() {
      while (items.length <= election.candidates.length) {
        items.add(Container());
      }
    }

    List<_Data> lastRoundData;
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

      // Only output place numbers on the first round and follow-up rounds
      // if the place data changes.
      if (lastRoundData == null ||
          !_dataIterableEquals(
              roundData, lastRoundData.take(roundData.length))) {
        // places
        items = <Widget>[
          Container(),
          for (var item in roundData)
            _cell(
              item.placeNumber.toString(),
              fontWeight: FontWeight.bold,
            ),
        ];
        fillItems();

        yield items;
      }

      lastRoundData = roundData;

      // candidates
      items = <Widget>[
        Container(),
        for (var item in roundData)
          _cell(
            item.candidate.id,
            fontWeight: FontWeight.bold,
            background: item.candidate.color,
          ),
      ];
      fillItems();

      yield items;

      // vote count
      items = <Widget>[
        _cell(
          'Round ${round.number}',
          fontWeight: FontWeight.bold,
        ),
        for (var item in roundData)
          _cell(
            item.place.voteCount.toString(),
            background: item.candidate.color,
          ),
      ];
      fillItems();

      yield items;

      // eliminations
      for (var elimination in round.eliminations) {
        Widget eliminationContent(TownCandidate candidate) {
          if (candidate == elimination.candidate) {
            return _cell('←');
          }

          final count = elimination.getTransferCount(candidate);
          if (count == 0) {
            return Container();
          }
          return _cell(count.toString());
        }

        items = <Widget>[
          _cell(
            elimination.candidate.id,
            textAlign: TextAlign.right,
            fontStyle: FontStyle.italic,
          ),
          for (var item in roundData) eliminationContent(item.candidate),
        ];
        fillItems();
        yield items;
      }
    }
  }
}

bool _dataIterableEquals(Iterable<_Data> a, Iterable<_Data> b) =>
    const IterableEquality<_Data>().equals(a, b);

class _Data {
  final int placeNumber;
  final TownCandidate candidate;
  final PluralityElectionPlace<TownCandidate> place;

  _Data(
    this.placeNumber,
    this.place,
    this.candidate,
  );

  @override
  bool operator ==(other) =>
      other is _Data &&
      placeNumber == other.placeNumber &&
      candidate == other.candidate;

  @override
  int get hashCode => placeNumber ^ 7 * candidate.hashCode;
}

Widget _cell(
  String content, {
  FontWeight fontWeight,
  Color background,
  TextAlign textAlign = TextAlign.center,
  FontStyle fontStyle,
}) =>
    Container(
      padding: const EdgeInsets.all(3),
      color: background,
      child: Text(
        content,
        textAlign: textAlign,
        style: (fontWeight == null && fontStyle == null)
            ? null
            : TextStyle(
                fontWeight: fontWeight,
                fontStyle: fontStyle,
              ),
      ),
    );
