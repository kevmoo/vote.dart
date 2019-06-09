import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import 'model/vote_town.dart';

class DistanceElectionResultWidget extends StatelessWidget {
  const DistanceElectionResultWidget();

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Consumer<VoteTown>(
          builder: (context, voteTown, _) => ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                itemCount: voteTown.places.length,
                itemBuilder: (ctx, index) {
                  final entry = voteTown.places[index];
                  final entryString = entry.map((s) => s.id).join(', ');
                  return Row(children: [
                    Expanded(
                      child: Text(
                        entry.place.toString(),
                        textAlign: TextAlign.right,
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        entryString,
                        textAlign: TextAlign.right,
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        entry.averageDistance.toString(),
                        textAlign: TextAlign.right,
                      ),
                      flex: 1,
                    ),
                  ]);
                },
              ),
        ),
      );
}
