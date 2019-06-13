import 'package:flutter_web/material.dart';
import 'package:knarly/src/model/town_candidate.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../model/vote_town.dart';
import 'table_helper.dart';

class PluralityElectionResultWidget extends StatelessWidget {
  const PluralityElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTown>(
        builder: (context, voteTown, __) => const _PluralityTableHelper().build(
          context,
          voteTown.pluralityElection.places,
        ),
      );
}

class _PluralityTableHelper
    extends TableHelper<PluralityElectionPlace<TownCandidate>, TownCandidate> {
  const _PluralityTableHelper();

  @override
  List<String> get columns => const ['Place', 'Candidate', 'Votes'];

  @override
  Color subEntryColor(TownCandidate subEntry) => subEntry.color;

  @override
  List<TownCandidate> subEntries(PluralityElectionPlace<TownCandidate> entry) =>
      entry;

  @override
  bool isMulti(int column) => column == 1;

  @override
  String textForColumn(
    int columnName,
    PluralityElectionPlace<TownCandidate> entry,
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
  String textForSubEntry(int columnName, TownCandidate subEntry) {
    if (columnName == 1) {
      return subEntry.id;
    }
    return super.textForSubEntry(columnName, subEntry);
  }
}
