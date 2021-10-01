import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_widgets/vote_widgets.dart';

import 'model/vote_town.dart';
import 'view_model/vote_town_editor.dart';
import 'widget/body_content.dart';
import 'widget/link_span.dart';
import 'widget/too_small.dart';

class VoteSimulation extends StatelessWidget {
  final _model = VoteTownEditor(VoteTown.random());

  VoteSimulation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Election Method Simulation',
        home: Scaffold(
          body: TooSmallWidget(
            minimumSize: const Size(_crossAxisWidth * 2, _crossAxisWidth),
            child: ChangeNotifierProvider<VoteTownEditor>.value(
              value: _model,
              child: NotificationMirror<VoteNotification>(
                transform: (input) => input.stop ? null : input,
                child: CustomScrollView(
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 20),
                      sliver: SliverToBoxAdapter(
                        child: BodyContent(
                          crossAxisWidth: _crossAxisWidth,
                        ),
                      ),
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
                              linkSpan(
                                _reportAProblemUrl,
                                text: 'Report a problem',
                              ),
                              const TextSpan(text: ' or '),
                              linkSpan(
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
        ),
      );
}

const _sourceUrl = 'https://github.com/kevmoo/vote.dart/tree/master/vote_demo';
const _reportAProblemUrl =
    'https://github.com/kevmoo/vote.dart/issues/new?template=problem-suggestion-for-vote-j832-com.md';

const _crossAxisWidth = 500.0;
