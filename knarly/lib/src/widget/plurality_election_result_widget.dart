import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import '../model/vote_town.dart';
import 'widget_util.dart';

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
            builder: (_, voteTown, __) => Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      children: [
                        tableHeader('Place'),
                        tableHeader('Candidate'),
                        tableHeader('Votes'),
                      ],
                    ),
                    ...voteTown.pluralityElection.places.map(
                      (entry) => TableRow(
                            decoration: entry.length == 1
                                ? BoxDecoration(color: entry.single.color)
                                : null,
                            children: [
                              Text(entry.place.toString()),
                              entry.length == 1
                                  ? Text(entry.single.id)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: List.generate(
                                        entry.length,
                                        (candidateIndex) {
                                          final candidate =
                                              entry[candidateIndex];
                                          return Text(
                                            candidate.id,
                                            style: TextStyle(
                                                backgroundColor:
                                                    candidate.color),
                                          );
                                        },
                                      ),
                                    ),
                              Text(entry.voteCount.toString()),
                            ],
                          ),
                    )
                  ],
                ),
          ),
        ),
      );
}
