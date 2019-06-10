import 'package:flutter_web/material.dart';
import 'package:provider/provider.dart';

import 'src/model/vote_town.dart';
import 'src/widget/distance_election_result_widget.dart';
import 'src/widget/plurality_election_result_widget.dart';
import 'src/widget/vote_town_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: MultiProvider(
            providers: const [
              Provider<VoteTown>(builder: _voteTownBuilder),
            ],
            child: GridView.extent(
              primary: false,
              padding: const EdgeInsets.all(10.0),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              maxCrossAxisExtent: 400,
              children: const [
                VoteTownWidget(),
                DistanceElectionResultWidget(),
                PluralityElectionResultWidget(),
              ],
            ),
          ),
        ),
      );
}

VoteTown _voteTownBuilder(_) => VoteTown.random();
