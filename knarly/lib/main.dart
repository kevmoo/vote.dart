import 'package:flutter_web/material.dart';
import 'package:knarly/src/view_model/simple_ballot_editor.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import 'src/helpers/k_grid.dart';
import 'src/model/candidate.dart';
import 'src/model/vote_town.dart';
import 'src/model/vote_town_distance_place.dart';
import 'src/view_model/knarly_view_model.dart';
import 'src/view_model/vote_town_editor.dart';
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
            child: ChangeNotifierProvider<KnarlyViewModel>(
              builder: _viewModel,
              child: Consumer<KnarlyViewModel>(
                builder: (_, kvm, __) => Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: _editor(kvm),
                    ),
                    Expanded(
                      child: KGrid(
                        maxCrossAxisExtent: 500,
                        children: _gridChildren(kvm),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

Widget _editor(KnarlyViewModel kvm) {
  Widget editorWidget;
  if (kvm.editor is VoteTownEditor) {
    editorWidget = ListenableProvider<VoteTownEditor>.value(
      value: kvm.editor as VoteTownEditor,
      child: const VoteTownWidget(),
    );
  } else {
    editorWidget = const Placeholder();
  }

  return Column(
    children: <Widget>[
      RaisedButton(
        child: const Text('Toggle'),
        onPressed: kvm.toggleFunction,
      ),
      editorWidget,
    ],
  );
}

List<Widget> _gridChildren(KnarlyViewModel value) => [
      if (value.electionData is VoteTown)
        _header(
          'Distance',
          Provider<List<VoteTownDistancePlace>>.value(
            value: (value.electionData as VoteTown).distancePlaces,
            child: const DistanceElectionResultWidget(),
          ),
        ),
      _header(
        'Plurality',
        Provider<PluralityElection<Candidate>>.value(
          value: value.electionData.pluralityElection,
          child: const PluralityElectionResultWidget(),
        ),
      ),
      _header(
        'Ranked Pairs',
        Provider<CondorcetElection<Candidate>>.value(
          value: value.electionData.condorcetElection,
          child: const CondorcetElectionResultWidget(),
        ),
      ),
      _header(
        'Ranked Choice',
        Provider<IrvElection<Candidate>>.value(
          value: value.electionData.irvElection,
          child: const RankedChoiceElectionResultWidget(),
        ),
      ),
    ];

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

KnarlyViewModel _viewModel(BuildContext ctx) => KnarlyViewModel(
      [
        VoteTownEditor(VoteTown.random()),
        SimpleBallotEditor(),
      ],
    );
