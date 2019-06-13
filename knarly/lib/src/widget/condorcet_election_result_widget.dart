import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../model/town_candidate.dart';
import '../model/town_voter.dart';
import '../model/vote_town.dart';
import 'table_helper.dart';

class CondorcetElectionResultWidget extends StatelessWidget {
  const CondorcetElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTown>(
        builder: (context, voteTown, __) => _CondorcetTableHelper(
          voteTown.condorcetElection,
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
  List<String> get columns =>
      ['Place', 'Candidate', ..._election.candidates.map((c) => c.id)];

  @override
  Color subEntryColor(TownCandidate subEntry) => subEntry.color;

  @override
  List<TownCandidate> subEntries(ElectionPlace<TownCandidate> entry) => entry;

  @override
  bool isMulti(int columnIndex) => columnIndex >= 1;

  @override
  String textForColumn(int columnIndex, ElectionPlace<TownCandidate> entry) {
    if (columnIndex == 0) {
      return entry.place.toString();
    }
    return super.textForColumn(columnIndex, entry);
  }

  @override
  String textForSubEntry(int columnIndex, TownCandidate subEntry) {
    if (columnIndex == 1) {
      return subEntry.id;
    }

    if (columnIndex > 1) {
      final columnCandidate = _election.candidates.elementAt(columnIndex - 2);
      if (columnCandidate == subEntry) {
        return '';
      }

      final pair = _election.getPair(subEntry, columnCandidate);

      final comparison =
          pair.isTie ? '=' : pair.winner == pair.candidate1 ? '>' : '<';

      return '${pair.firstOverSecond} $comparison ${pair.secondOverFirst}';
    }
    return super.textForSubEntry(columnIndex, subEntry);
  }

  @override
  TableColumnWidth get defaultTableColumnWidth => const IntrinsicColumnWidth();

  @override
  // TODO: implement fontSizeFactor
  double get fontSizeFactor => 1.0;
}
