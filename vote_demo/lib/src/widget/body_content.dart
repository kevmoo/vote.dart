import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';
import 'package:vote_widgets/vote_widgets.dart';

import '../model/vote_town_distance_place.dart';
import '../view_model/vote_town_editor.dart';
import 'distance_election_result_widget.dart';
import 'header_widget.dart';
import 'k_grid.dart';
import 'link_span.dart';
import 'vote_town_widget.dart';

class BodyContent extends StatelessWidget {
  final double crossAxisWidth;

  const BodyContent({required this.crossAxisWidth, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          Consumer<VoteTownEditor>(
            builder: (_, kvm, __) => LayoutBuilder(
              builder: (context, data) {
                if (data.maxWidth > 2 * crossAxisWidth) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: crossAxisWidth,
                        ),
                        child: Column(
                          children: _columnOneChildren(kvm),
                        ),
                      ),
                      Flexible(
                        child: KGrid(
                          maxCrossAxisExtent: crossAxisWidth,
                          children: _columnTwoChildren(kvm),
                        ),
                      ),
                    ],
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: crossAxisWidth,
                  ),
                  child: Column(
                    children: [
                      ..._columnOneChildren(kvm),
                      ..._columnTwoChildren(kvm),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );

  List<Widget> _columnOneChildren(VoteTownEditor kvm) => <Widget>[
        const HeaderWidget(
          header: 'Vote Town',
          extraHelp:
              'A simple town of 100 people trying to figure out where their '
              'post office should go.',
          child: VoteTownWidget(),
        ),
        HeaderWidget(
          header: 'Place by average distance',
          extraHelp:
              'The candidate locations ranked by their distance to the "ideal" '
              'location in the center of town.',
          child: Provider<List<VoteTownDistancePlace>>.value(
            value: (kvm.value).distancePlaces,
            child: const DistanceElectionResultWidget(),
          ),
        ),
      ];

  List<Widget> _columnTwoChildren(VoteTownEditor kvm) => [
        HeaderWidget(
          header: 'Plurality',
          extraHelp: TextSpan(
            children: [
              const TextSpan(
                text: 'The result of a typical "pick your favorite" election - '
                    'as if every voter cast a ballot for just their favorite '
                    '(closest) candidate. See ',
              ),
              linkSpan('https://wikipedia.org/wiki/Plurality_voting'),
            ],
          ),
          child: Provider<PluralityElection<Candidate>>.value(
            value: kvm.value.pluralityElection,
            child: const PluralityElectionResultWidget(),
          ),
        ),
        HeaderWidget(
          header: 'Condorcet',
          extraHelp: TextSpan(
            children: [
              const TextSpan(text: 'A '),
              linkSpan(
                'https://en.wikipedia.org/wiki/Ranked_voting',
                text: 'ranked voting method',
              ),
              const TextSpan(
                text:
                    ' which calculates the winner by evaluating every pair of '
                    'candidates. See ',
              ),
              linkSpan('https://en.wikipedia.org/wiki/Condorcet_method'),
            ],
          ),
          child: CondorcetElectionResultWidget<Candidate>(
            election: kvm.value.condorcetElection,
          ),
        ),
        HeaderWidget(
          header: 'Instant-runoff voting',
          extraHelp: TextSpan(
            children: [
              const TextSpan(text: 'A '),
              linkSpan(
                'https://en.wikipedia.org/wiki/Ranked_voting',
                text: 'ranked voting method',
              ),
              const TextSpan(
                text: ' which calculates the winner by repeatedly calculating '
                    'run-offs where the candidate with the fewest #1 rankings '
                    'is eliminated. See ',
              ),
              linkSpan('https://wikipedia.org/wiki/Instant-runoff_voting'),
            ],
          ),
          child: Provider<IrvElection<Candidate>>.value(
            value: kvm.value.irvElection,
            child: const IrvResultWidget(),
          ),
        ),
      ];
}
