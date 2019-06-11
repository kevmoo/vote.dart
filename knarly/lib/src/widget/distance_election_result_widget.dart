import 'package:flutter_web/material.dart';
import 'package:knarly/src/model/town_candidate.dart';
import 'package:provider/provider.dart';

import '../model/vote_town.dart';
import '../model/vote_town_distance_place.dart';
import 'table_helper.dart';

class DistanceElectionResultWidget extends StatelessWidget {
  const DistanceElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTown>(
        builder: (context, voteTown, __) => const _DistancePlaceRowInfo().build(
          context,
          voteTown.distancePlaces,
        ),
      );
}

class _DistancePlaceRowInfo
    extends TableHelper<VoteTownDistancePlace, TownCandidate> {
  const _DistancePlaceRowInfo();

  @override
  List<String> get columns => const ['Place', 'Candidate', 'Distance'];

  @override
  Color subEntryColor(TownCandidate subEntry) => subEntry.color;

  @override
  List<TownCandidate> subEntries(VoteTownDistancePlace entry) => entry;

  @override
  bool isMulti(String column) => column == 'Candidate';

  @override
  String textForColumn(String columnName, VoteTownDistancePlace entry) {
    switch (columnName) {
      case 'Place':
        return entry.place.toString();
      case 'Distance':
        return entry.averageDistance.toStringAsFixed(2);
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
