import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import 'model/vote_town.dart';

class DistanceElectionResultWidget extends StatelessWidget {
  const DistanceElectionResultWidget();

  @override
  Widget build(BuildContext context) => Consumer<VoteTown>(
        builder: (context, voteTown, _) => ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: voteTown.places.length,
              itemBuilder: (ctx, index) {
                final entry = voteTown.places[index];
                final entryString = entry.map((s) => s.id).join(', ');
                return Container(
                  child: Text('$entryString - ${entry.averageDistance}'),
                );
              },
            ),
      );
}
