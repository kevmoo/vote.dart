import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import 'src/helpers/k_grid.dart';
import 'src/model/vote_town.dart';
import 'src/vote_town_notifier.dart';
import 'src/widget/condorcet_election_result_widget.dart';
import 'src/widget/distance_election_result_widget.dart';
import 'src/widget/plurality_election_result_widget.dart';
import 'src/widget/ranked_choice_election_result_widget.dart';
import 'src/widget/vote_town_widget.dart';

void main() => runApp(const VoteSimulation());

class VoteSimulation extends StatelessWidget {
  const VoteSimulation();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: ChangeNotifierProvider<VoteTownNotifier>(
              builder: _voteTownBuilder,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: const VoteTownWidget(),
                  ),
                  Expanded(
                    child: KGrid(
                      maxCrossAxisExtent: 500,
                      children: [
                        _header(
                          'Distance',
                          const DistanceElectionResultWidget(),
                        ),
                        _header(
                          'Plurality',
                          const PluralityElectionResultWidget(),
                        ),
                        _header(
                          'Ranked Pairs',
                          const CondorcetElectionResultWidget(),
                        ),
                        _header(
                          'Ranked Choice',
                          const RankedChoiceElectionResultWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

Widget _header(String header, Widget widget) => Padding(
      padding: const EdgeInsets.all(5),
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
