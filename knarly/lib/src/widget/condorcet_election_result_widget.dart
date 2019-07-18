import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../helpers/table_helper.dart';
import '../model/candidate.dart';
import '../model/voter.dart';

class CondorcetElectionResultWidget extends StatelessWidget {
  const CondorcetElectionResultWidget();

  @override
  Widget build(BuildContext context) =>
      Consumer<CondorcetElection<Voter, Candidate>>(
        builder: (context, condorcetElection, __) => _CondorcetTableHelper(
          condorcetElection,
        ).build(context),
      );
}

class _CondorcetTableHelper
    extends TableHelper<ElectionPlace<Candidate>, Candidate> {
  @override
  List<ElectionPlace<Candidate>> get places => _election.places;

  final CondorcetElection<Voter, Candidate> _election;

  const _CondorcetTableHelper(this._election);

  @override
  List<String> get columns => [
        'Place',
        Candidate.candidateString,
        ..._election.candidates.map((c) => c.id),
      ];

  @override
  Color subEntryColor(Candidate subEntry) => subEntry.color;

  @override
  List<Candidate> subEntriesForEntry(ElectionPlace<Candidate> entry) => entry;

  @override
  bool isMulti(int columnIndex) => columnIndex != 0;

  @override
  String textForColumn(int columnIndex, ElectionPlace<Candidate> entry) {
    if (columnIndex == 0) {
      return entry.place.toString();
    }
    return super.textForColumn(columnIndex, entry);
  }

  @override
  Widget widgetForSubEntry(
      int columnIndex, Candidate subEntry, SubEntryPosition position) {
    String textContent;
    TextStyle style;

    if (columnIndex == 1) {
      textContent = subEntry.id;
    } else if (columnIndex > 1) {
      final columnCandidate = _election.candidates.elementAt(columnIndex - 2);

      if (columnCandidate == subEntry) {
        textContent = '';
      } else {
        final pair = _election.getPair(subEntry, columnCandidate);

        if (pair.isTie) {
          style = const TextStyle(fontStyle: FontStyle.italic);
        } else if (pair.winner == subEntry) {
          style = const TextStyle(fontWeight: FontWeight.bold);
        }

        final comparison =
            pair.isTie ? '=' : pair.winner == pair.candidate1 ? '>' : '<';
        textContent =
            '${pair.firstOverSecond}$comparison${pair.secondOverFirst}';
      }
    }

    return Container(
      color: subEntry.color,
      // This is some very nuanced logic for making sure the sizes of rows
      // are consistent as they are merged and un-merged
      padding: EdgeInsets.fromLTRB(
        2,
        position == SubEntryPosition.last || position == SubEntryPosition.middle
            ? 4
            : 2,
        2,
        2,
      ),
      child: Text(
        textContent,
        style: style,
      ),
    );
  }

  @override
  TableColumnWidth get defaultTableColumnWidth => const IntrinsicColumnWidth();
}
