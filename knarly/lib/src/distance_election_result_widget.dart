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
                  return Row(children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        entry.place.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          entry.length,
                          (candidateIndex) {
                            final candidate = entry[candidateIndex];
                            return Text(
                              candidate.id,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(backgroundColor: candidate.color),
                            );
                          },
                        ),
                      ),
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
