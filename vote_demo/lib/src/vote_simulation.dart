import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:vote/vote.dart';
import 'package:vote_widgets/vote_widgets.dart';

import 'helpers/k_grid.dart';
import 'model/vote_town.dart';
import 'model/vote_town_distance_place.dart';
import 'view_model/vote_town_editor.dart';
import 'widget/distance_election_result_widget.dart';
import 'widget/vote_town_widget.dart';

const _sourceUrl = 'github.com/kevmoo/vote.dart';
final _sourceUri = Uri.parse('https://$_sourceUrl');

final _value = VoteTownEditor(VoteTown.random());

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
          body: ChangeNotifierProvider<VoteTownEditor>.value(
            value: _value,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Center(
                child: Consumer<VoteTownEditor>(
                  builder: (_, kvm, __) =>
                      LayoutBuilder(builder: (context, data) {
                    if (data.maxWidth > 2 * _crossAxisWidth) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: _crossAxisWidth),
                            child: Column(children: _columnOneChildren(kvm)),
                          ),
                          Flexible(
                            child: KGrid(
                              maxCrossAxisExtent: _crossAxisWidth,
                              children: _columnTwoChildren(kvm),
                            ),
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

  List<Widget> _columnOneChildren(VoteTownEditor kvm) => <Widget>[
        ListenableProvider<VoteTownEditor>.value(
          value: kvm,
          child: const VoteTownWidget(),
        ),
        Provider<List<VoteTownDistancePlace>>.value(
          value: (kvm.value).distancePlaces,
          child: const DistanceElectionResultWidget(),
        ),
      ];

  List<Widget> _columnTwoChildren(VoteTownEditor kvm) => [
        _HeaderWidget(
          header: 'Plurality',
          child: Provider<PluralityElection<Candidate>>.value(
            value: kvm.value.pluralityElection,
            child: const PluralityElectionResultWidget(),
          ),
        ),
        _HeaderWidget(
          header: 'Condorcet',
          child: CondorcetElectionResultWidget<Candidate>(
            election: kvm.value.condorcetElection,
          ),
        ),
        _HeaderWidget(
          header: 'Ranked Choice',
          child: Provider<IrvElection<Candidate>>.value(
            value: kvm.value.irvElection,
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
