import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:vote/vote.dart';
import 'package:vote_widgets/vote_widgets.dart';

import 'helpers/k_grid.dart';
import 'model/vote_town.dart';
import 'model/vote_town_distance_place.dart';
import 'view_model/knarly_view_model.dart';
import 'view_model/simple_ballot_editor.dart';
import 'view_model/vote_town_editor.dart';
import 'widget/distance_election_result_widget.dart';
import 'widget/simple_editor_widget.dart';
import 'widget/vote_town_widget.dart';

const _sourceUrl = 'github.com/kevmoo/vote.dart';
final _sourceUri = Uri.parse('https://$_sourceUrl');

final _value = _viewModel();

class VoteSimulation extends StatelessWidget {
  const VoteSimulation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Election Method Simulation',
        home: Scaffold(
          bottomNavigationBar: Link(
            uri: _sourceUri,
            target: LinkTarget.blank,
            builder: (context, followLink) => ElevatedButton(
              onPressed: followLink,
              child: const Text('Source: $_sourceUrl'),
            ),
          ),
          body: ChangeNotifierProvider<KnarlyViewModel>.value(
            value: _value,
            child: Consumer<KnarlyViewModel>(
              builder: (_, kvm, __) => SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                child: Center(
                  child: LayoutBuilder(builder: (context, data) {
                    if (data.maxWidth > 2 * _crossAxisWidth) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: _crossAxisWidth),
                            child: Column(children: _columnOneChildren(kvm)),
                          ),
                          Expanded(
                            child: KGrid(
                                maxCrossAxisExtent: _crossAxisWidth,
                                children: _columnTwoChildren(kvm)),
                          ),
                        ],
                      );
                    }

                    return ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: _crossAxisWidth),
                      child: Column(children: [
                        ..._columnOneChildren(kvm),
                        ..._columnTwoChildren(kvm),
                      ]),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      );

  List<Widget> _columnOneChildren(KnarlyViewModel kvm) => <Widget>[
        ElevatedButton(
          onPressed: kvm.toggleFunction,
          child: const Text('Toggle'),
        ),
        if (kvm.editor is VoteTownEditor) ...[
          ListenableProvider<VoteTownEditor>.value(
            value: kvm.editor as VoteTownEditor,
            child: const VoteTownWidget(),
          ),
          Provider<List<VoteTownDistancePlace>>.value(
            value: (kvm.editor.value as VoteTown).distancePlaces,
            child: const DistanceElectionResultWidget(),
          ),
        ] else
          ListenableProvider<SimpleBallotEditor>.value(
            value: kvm.editor as SimpleBallotEditor,
            child: const SimpleEditorWidget(),
          ),
      ];

  List<Widget> _columnTwoChildren(KnarlyViewModel kvm) => [
        _HeaderWidget(
          header: 'Plurality',
          child: Provider<PluralityElection<Candidate>>.value(
            value: kvm.editor.value.pluralityElection,
            child: const PluralityElectionResultWidget(),
          ),
        ),
        _HeaderWidget(
          header: 'Condorcet',
          child: CondorcetElectionResultWidget<Candidate>(
            kvm.editor.value.condorcetElection,
          ),
        ),
        _HeaderWidget(
          header: 'Ranked Choice',
          child: Provider<IrvElection<Candidate>>.value(
            value: kvm.editor.value.irvElection,
            child: const RankedChoiceElectionResultWidget(),
          ),
        ),
      ];
}

const _crossAxisWidth = 500.0;

class _HeaderWidget extends StatelessWidget {
  final String header;
  final Widget child;
  const _HeaderWidget({
    Key? key,
    required this.header,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              header,
              style: Theme.of(context).textTheme.headline5,
            ),
            child,
          ],
        ),
      );
}

KnarlyViewModel _viewModel() {
  final data = VoteTown.random();

  return KnarlyViewModel(
    [
      VoteTownEditor(data),
      SimpleBallotEditor(electionData: data),
    ],
  );
}
