import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../../helpers.dart';
import '../model/candidate.dart';

class PluralityElectionResultWidget extends StatelessWidget {
  const PluralityElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<PluralityElection<Candidate>>(
        builder: (context, value, __) =>
            _PluralityTableHelper(value.places).build(context),
      );
}

class _PluralityTableHelper
    extends TableHelper<PluralityElectionPlace<Candidate>, Candidate> {
  @override
  final List<PluralityElectionPlace<Candidate>> places;

  const _PluralityTableHelper(this.places);

  @override
  List<String> get columns => const [
        'Place',
        candidateString,
        'Votes',
      ];

  @override
  Color subEntryColor(Candidate subEntry) => subEntry.color;

  @override
  List<Candidate> subEntriesForEntry(PluralityElectionPlace<Candidate> entry) =>
      entry;

  @override
  bool isMulti(int column) => column == 1;

  @override
  String textForColumn(
    int columnName,
    PluralityElectionPlace<Candidate> entry,
  ) {
    switch (columnName) {
      case 0:
        return entry.place.toString();
      case 2:
        return entry.voteCount.toString();
    }
    return super.textForColumn(columnName, entry);
  }

  @override
  String textForSubEntry(int columnName, Candidate subEntry) {
    if (columnName == 1) {
      return subEntry.id;
    }
    return super.textForSubEntry(columnName, subEntry);
  }
}
