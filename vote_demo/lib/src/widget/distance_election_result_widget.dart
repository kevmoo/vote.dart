import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_simulation/vote_simulation.dart';
import 'package:vote_widgets/helpers.dart';

class const DistanceElectionResultWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<List<VoteTownDistancePlace>>(
    builder: (context, distancePlaces, _) =>
        _DistancePlaceRowInfo(distancePlaces).build(context),
  );
}

class const _DistancePlaceRowInfo(
  @override final List<VoteTownDistancePlace> places,
) extends TableHelper<VoteTownDistancePlace> {
  @override
  List<Object> get columns => const ['Place', Icons.person, 'Distance'];

  @override
  String textForColumn(int columnName, VoteTownDistancePlace entry) =>
      columnName == 2
      ? entry.averageDistance.toStringAsFixed(2)
      : super.textForColumn(columnName, entry);
}
