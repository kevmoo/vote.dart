import 'package:flutter_web/material.dart';
import 'package:knarly/src/vote_town_notifier.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../model/town_candidate.dart';
import '../model/town_voter.dart';
import 'table_helper.dart';

class CondorcetElectionResultWidget extends StatelessWidget {
  const CondorcetElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTownNotifier>(
        builder: (context, notifier, __) => _CondorcetTableHelper(
          notifier.value.condorcetElection,
        ).build(context),
      );
}

class _CondorcetTableHelper
    extends TableHelper<ElectionPlace<TownCandidate>, TownCandidate> {
  @override
  List<ElectionPlace<TownCandidate>> get places => _election.places;

  final CondorcetElection<TownVoter, TownCandidate> _election;

  const _CondorcetTableHelper(this._election);

  @override
  List<String> get columns => [
        'Place',
        TownCandidate.candidateString,
        ..._election.candidates.map((c) => c.id),
      ];

  @override
  Color subEntryColor(TownCandidate subEntry) => subEntry.color;

  @override
  List<TownCandidate> subEntriesForEntry(ElectionPlace<TownCandidate> entry) =>
      entry;

  @override
  bool isMulti(int columnIndex) => columnIndex != 0;

  @override
  String textForColumn(int columnIndex, ElectionPlace<TownCandidate> entry) {
    if (columnIndex == 0) {
      return entry.place.toString();
    }
    return super.textForColumn(columnIndex, entry);
  }

  @override
  Widget widgetForSubEntry(
      int columnIndex, TownCandidate subEntry, bool isMulti) {
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
      margin: const EdgeInsets.symmetric(vertical: 1),
      color: subEntry.color,
      padding: const EdgeInsets.all(2),
      child: Text(
        textContent,
        style: style,
      ),
    );
  }

  @override
  TableColumnWidth get defaultTableColumnWidth => const IntrinsicColumnWidth();
}
