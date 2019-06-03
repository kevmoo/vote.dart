import 'package:flutter_web/material.dart';
import 'package:knarly/src/model.dart';
import 'package:provider/provider.dart';

import 'src/vote_town_widget.dart';

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
        home: MultiProvider(
          providers: const [
            Provider<VoteTown>(builder: _voteTownBuilder),
          ],
          child: GridView.extent(
            primary: false,
            padding: const EdgeInsets.all(20.0),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            maxCrossAxisExtent: 500,
            children: const [
              VoteTownWidget(),
              Placeholder(),
            ],
          ),
        ),
      );
}

VoteTown _voteTownBuilder(_) => VoteTown.random();
