import 'package:flutter/material.dart';
import 'package:vote/vote.dart';

import '../helpers/helpers.dart';
import '../helpers/table_helper.dart';
import '../model/candidate.dart';

class CondorcetElectionResultWidget<TCandidate extends Comparable<TCandidate>>
    extends StatelessWidget {
  final CondorcetElectionResult<TCandidate> condorcetElectionResult;

  const CondorcetElectionResultWidget(this.condorcetElectionResult);

  @override
  Widget build(BuildContext context) => _CondorcetTableHelper<TCandidate>(
        condorcetElectionResult,
      ).build(context);
}

class _CondorcetTableHelper<TCandidate extends Comparable<TCandidate>>
    extends TableHelper<ElectionPlace<TCandidate>, TCandidate> {
  @override
  List<ElectionPlace<TCandidate>> get places => _election.places;

  final CondorcetElectionResult<TCandidate> _election;

  late final Map<TCandidate, Color> _candidateColors =
      huesForCandidates(_election.candidates);

  _CondorcetTableHelper(this._election);

  @override
  List<String> get columns => [
        'Place',
        Candidate.candidateString,
        ..._election.candidates.map(_idForCandidate),
      ];

  @override
  Color subEntryColor(TCandidate subEntry) => _colorForCandidate(subEntry);

  @override
  List<TCandidate> subEntriesForEntry(ElectionPlace<TCandidate> entry) => entry;

  @override
  bool isMulti(int columnIndex) => columnIndex != 0;

  @override
  String textForColumn(int columnIndex, ElectionPlace<TCandidate> entry) {
    if (columnIndex == 0) {
      return entry.place.toString();
    }
    return super.textForColumn(columnIndex, entry);
  }

  @override
  Widget widgetForSubEntry(
    int columnIndex,
    TCandidate subEntry,
    SubEntryPosition position,
  ) {
    String textContent;
    TextStyle? style;

    if (columnIndex == 1) {
      textContent = _idForCandidate(subEntry);
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

        final comparison = pair.isTie
            ? '='
            : pair.winner == pair.candidate1
                ? '>'
                : '<';
        textContent =
            '${pair.firstOverSecond}$comparison${pair.secondOverFirst}';
      }
    } else {
      throw UnsupportedError(
        'Not sure what to do here - columnIndex $columnIndex',
      );
    }

    return Container(
      color: _colorForCandidate(subEntry),
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

  String _idForCandidate(Object candidate) {
    if (candidate is Candidate) {
      return candidate.id;
    }
    return candidate.toString();
  }

  Color _colorForCandidate(TCandidate candidate) =>
      _candidateColors[candidate]!;
}
