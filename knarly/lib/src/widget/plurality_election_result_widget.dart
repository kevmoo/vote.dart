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
        builder: (context, voteTown, __) =>
            const _PluralityTableHelper().createTable(
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
  bool isMulti(String column) => column == 'Candidate';

  @override
  String textForColumn(
      String columnName, PluralityElectionPlace<TownCandidate> entry) {
    switch (columnName) {
      case 'Place':
        return entry.place.toString();
      case 'Votes':
        return entry.voteCount.toString();
    }
    return super.textForColumn(columnName, entry);
  }

  @override
  String textForSubEntry(String columnName, TownCandidate subEntry) {
    if (columnName == 'Candidate') {
      return subEntry.id;
    }
    return super.textForSubEntry(columnName, subEntry);
  }
}
