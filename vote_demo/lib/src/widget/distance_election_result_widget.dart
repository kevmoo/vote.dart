import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_widgets/helpers.dart';
import 'package:vote_widgets/vote_widgets.dart';

import '../model/vote_town_distance_place.dart';

class DistanceElectionResultWidget extends StatelessWidget {
  const DistanceElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<List<VoteTownDistancePlace>>(
    builder:
        (context, distancePlaces, __) =>
            _DistancePlaceRowInfo(distancePlaces).build(context),
  );
}

class _DistancePlaceRowInfo
    extends TableHelper<VoteTownDistancePlace, Candidate> {
  @override
  final List<VoteTownDistancePlace> places;

  const _DistancePlaceRowInfo(this.places);

  @override
  List<Object> get columns => const ['Place', Icons.person, 'Distance'];

  @override
  Color subEntryColor(Candidate subEntry) => subEntry.color;

  @override
  List<Candidate> subEntriesForEntry(VoteTownDistancePlace entry) => entry;

  @override
  bool isMulti(int column) => column == 1;

  @override
  String textForColumn(int columnName, VoteTownDistancePlace entry) =>
      switch (columnName) {
        0 => entry.place.toString(),
        2 => entry.averageDistance.toStringAsFixed(2),
        _ => super.textForColumn(columnName, entry),
      };

  @override
  String textForSubEntry(int columnName, Candidate subEntry) {
    if (columnName == 1) {
      return subEntry.id;
    }
    return super.textForSubEntry(columnName, subEntry);
  }
}
