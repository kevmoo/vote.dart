import 'package:flutter_web/material.dart';
import 'package:knarly/src/model/town_candidate.dart';
import 'package:knarly/src/vote_town_notifier.dart';
import 'package:provider/provider.dart';

import '../model/vote_town_distance_place.dart';
import 'table_helper.dart';

class DistanceElectionResultWidget extends StatelessWidget {
  const DistanceElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTownNotifier>(
        builder: (context, notifier, __) =>
            _DistancePlaceRowInfo(notifier.value.distancePlaces).build(context),
      );
}

class _DistancePlaceRowInfo
    extends TableHelper<VoteTownDistancePlace, TownCandidate> {
  @override
  final List<VoteTownDistancePlace> places;

  const _DistancePlaceRowInfo(this.places);

  @override
  List<String> get columns => const [
        'Place',
        TownCandidate.candidateString,
        'Distance',
      ];

  @override
  Color subEntryColor(TownCandidate subEntry) => subEntry.color;

  @override
  List<TownCandidate> subEntriesForEntry(VoteTownDistancePlace entry) => entry;

  @override
  bool isMulti(int column) => column == 1;

  @override
  String textForColumn(int columnName, VoteTownDistancePlace entry) {
    switch (columnName) {
      case 0:
        return entry.place.toString();
      case 2:
        return entry.averageDistance.toStringAsFixed(2);
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
