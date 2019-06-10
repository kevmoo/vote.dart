import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import '../model/vote_town.dart';

class PluralityElectionResultWidget extends StatelessWidget {
  const PluralityElectionResultWidget();

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
        textAlign: TextAlign.center,
        style: DefaultTextStyle.of(context).style.apply(
              fontSizeFactor: 2.0,
            ),
        child: Container(
          alignment: Alignment.center,
          child: Consumer<VoteTown>(
            builder: (context, voteTown, _) => ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: voteTown.pluralityElection.places.length,
                  itemBuilder: (ctx, index) {
                    final entry = voteTown.pluralityElection.places[index];
                    return Container(
                      color: entry.length == 1 ? entry.single.color : null,
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            entry.place.toString(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: entry.length == 1
                              ? Text(
                                  entry.single.id,
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: List.generate(
                                    entry.length,
                                    (candidateIndex) {
                                      final candidate = entry[candidateIndex];
                                      return Text(
                                        candidate.id,
                                        style: TextStyle(
                                            backgroundColor: candidate.color),
                                      );
                                    },
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Text(entry.voteCount.toString()),
                          flex: 1,
                        ),
                      ]),
                    );
                  },
                ),
          ),
        ),
      );
}
