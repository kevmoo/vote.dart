import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vote/vote.dart';
import 'package:vote_widgets/vote_widgets.dart';

import 'helpers/k_grid.dart';
import 'model/vote_town.dart';
import 'model/vote_town_distance_place.dart';
import 'view_model/vote_town_editor.dart';
import 'widget/distance_election_result_widget.dart';
import 'widget/header_widget.dart';
import 'widget/too_small.dart';
import 'widget/vote_town_widget.dart';

class VoteSimulation extends StatelessWidget {
  const VoteSimulation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Election Method Simulation',
        home: Scaffold(
          body: TooSmallWidget(
            minimumSize: const Size(_crossAxisWidth * 2, _crossAxisWidth),
            child: ChangeNotifierProvider<VoteTownEditor>.value(
              value: _model,
              child: CustomScrollView(
                slivers: [
                  const SliverPadding(
                    padding: EdgeInsets.only(bottom: 20),
                    sliver: SliverToBoxAdapter(child: _BodyContent()),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      color: Colors.grey.shade300,
                      padding: const EdgeInsets.only(top: 10, bottom: 12),
                      alignment: Alignment.topCenter,
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            _linkSpan(
                              _reportAProblemUrl,
                              text: 'Report a problem',
                            ),
                            const TextSpan(text: ' or '),
                            _linkSpan(
                              _sourceUrl,
                              text: 'View the source code',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _BodyContent extends StatelessWidget {
  const _BodyContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          Consumer<VoteTownEditor>(
            builder: (_, kvm, __) => LayoutBuilder(
              builder: (context, data) {
                if (data.maxWidth > 2 * _crossAxisWidth) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _crossAxisWidth,
                        ),
                        child: Column(
                          children: _columnOneChildren(kvm),
                        ),
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
                  constraints: const BoxConstraints(
                    maxWidth: _crossAxisWidth,
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
        HeaderWidget(
          header: 'Vote Town',
          extraHelp:
              'A simple town of 100 people trying to figure out where their '
              'post office should go.',
          child: ListenableProvider<VoteTownEditor>.value(
            value: kvm,
            child: const VoteTownWidget(),
          ),
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
              _linkSpan('https://wikipedia.org/wiki/Plurality_voting'),
            ],
          ),
          child: Provider<PluralityElection<Candidate>>.value(
            value: kvm.value.pluralityElection,
            child: const PluralityElectionResultWidget(),
          ),
        ),
        HeaderWidget(
          header: 'Ranked Pairs',
          extraHelp: TextSpan(
            children: [
              const TextSpan(text: 'A '),
              _linkSpan(
                'https://en.wikipedia.org/wiki/Ranked_voting',
                text: 'ranked voting method',
              ),
              const TextSpan(
                text:
                    ' which calculates the winner by evaluating every pair of '
                    'candidates. See ',
              ),
              _linkSpan('https://wikipedia.org/wiki/Ranked_pairs'),
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
              _linkSpan(
                'https://en.wikipedia.org/wiki/Ranked_voting',
                text: 'ranked voting method',
              ),
              const TextSpan(
                text: ' which calculates the winner by repeatedly calculating '
                    'run-offs where the candidate with the fewest #1 rankings '
                    'is eliminated. See ',
              ),
              _linkSpan('https://wikipedia.org/wiki/Instant-runoff_voting'),
            ],
          ),
          child: Provider<IrvElection<Candidate>>.value(
            value: kvm.value.irvElection,
            child: const RankedChoiceElectionResultWidget(),
          ),
        ),
      ];
}

String _trimUrl(String url) {
  const httpsStart = 'https://';
  if (url.startsWith(httpsStart)) {
    return url.substring(httpsStart.length);
  }
  return url;
}

TextSpan _linkSpan(
  String url, {
  String? text,
  Color linkColor = Colors.lightBlue,
}) =>
    TextSpan(
      text: text ?? _trimUrl(url),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launch(url);
        },
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: linkColor,
      ),
      mouseCursor: SystemMouseCursors.click,
    );

const _sourceUrl = 'https://github.com/kevmoo/vote.dart/tree/master/vote_demo';
const _reportAProblemUrl =
    'https://github.com/kevmoo/vote.dart/issues/new?template=problem-suggestion-for-vote-j832-com.md';

final _model = VoteTownEditor(VoteTown.random());
const _crossAxisWidth = 500.0;
