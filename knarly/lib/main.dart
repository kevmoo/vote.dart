import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import 'src/model/vote_town.dart';
import 'src/vote_town_notifier.dart';
import 'src/widget/condorcet_election_result_widget.dart';
import 'src/widget/distance_election_result_widget.dart';
import 'src/widget/plurality_election_result_widget.dart';
import 'src/widget/vote_town_widget.dart';

void main() => runApp(const VoteSimulation());

class VoteSimulation extends StatelessWidget {
  const VoteSimulation();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(15),
            child: ChangeNotifierProvider<VoteTownNotifier>(
              builder: _voteTownBuilder,
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(500),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    const VoteTownWidget(),
                    _header('Distance', const DistanceElectionResultWidget()),
                  ]),
                  TableRow(children: [
                    _header('Plurality', const PluralityElectionResultWidget()),
                    _header('Condorcet', const CondorcetElectionResultWidget()),
                  ]),
                ],
              ),
            ),
          ),
        ),
      );
}

Widget _header(String header, Widget widget) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            header,
            textScaleFactor: 2,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          widget,
        ],
      ),
    );

VoteTownNotifier _voteTownBuilder(_) =>
    VoteTownNotifier(VoteTown.random(randomSeed: null));
