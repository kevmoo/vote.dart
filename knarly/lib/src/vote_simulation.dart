import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import 'helpers/k_grid.dart';
import 'model/candidate.dart';
import 'model/vote_town.dart';
import 'model/vote_town_distance_place.dart';
import 'view_model/knarly_view_model.dart';
import 'view_model/simple_ballot_editor.dart';
import 'view_model/vote_town_editor.dart';
import 'widget/condorcet_election_result_widget.dart';
import 'widget/distance_election_result_widget.dart';
import 'widget/plurality_election_result_widget.dart';
import 'widget/ranked_choice_election_result_widget.dart';
import 'widget/simple_editor_widget.dart';
import 'widget/vote_town_widget.dart';

class VoteSimulation extends StatelessWidget {
  const VoteSimulation();

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: ChangeNotifierProvider<KnarlyViewModel>(
              create: _viewModel,
              child: Consumer<KnarlyViewModel>(
                builder: (_, kvm, __) => Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Toggle'),
                            onPressed: kvm.toggleFunction,
                          ),
                          if (kvm.editor is VoteTownEditor) ...[
                            ListenableProvider<VoteTownEditor>.value(
                              value: kvm.editor as VoteTownEditor,
                              child: const VoteTownWidget(),
                            ),
                            Provider<List<VoteTownDistancePlace>>.value(
                              value:
                                  (kvm.editor.value as VoteTown).distancePlaces,
                              child: const DistanceElectionResultWidget(),
                            ),
                          ] else
                            ListenableProvider<SimpleBallotEditor>.value(
                              value: kvm.editor as SimpleBallotEditor,
                              child: const SimpleEditorWidget(),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: KGrid(
                        maxCrossAxisExtent: 500,
                        children: [
                          _header(
                            'Plurality',
                            Provider<PluralityElection<Candidate>>.value(
                              value: kvm.editor.value.pluralityElection,
                              child: const PluralityElectionResultWidget(),
                            ),
                          ),
                          _header(
                            'Ranked Pairs',
                            Provider<CondorcetElection<Candidate>>.value(
                              value: kvm.editor.value.condorcetElection,
                              child: const CondorcetElectionResultWidget(),
                            ),
                          ),
                          _header(
                            'Ranked Choice',
                            Provider<IrvElection<Candidate>>.value(
                              value: kvm.editor.value.irvElection,
                              child: const RankedChoiceElectionResultWidget(),
                            ),
                          ),
                        ],
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

KnarlyViewModel _viewModel(BuildContext ctx) {
  final data = VoteTown.random();

  return KnarlyViewModel(
    [
      VoteTownEditor(data),
      SimpleBallotEditor(electionData: data),
    ],
  );
}
