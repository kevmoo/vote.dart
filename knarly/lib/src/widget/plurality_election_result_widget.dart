import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../helpers/table_helper.dart';
import '../model/candidate.dart';
import '../vote_town_notifier.dart';

class PluralityElectionResultWidget extends StatelessWidget {
  const PluralityElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTownNotifier>(
        builder: (context, notifier, __) =>
            _PluralityTableHelper(notifier.value.pluralityElection.places)
                .build(context),
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
        Candidate.candidateString,
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
