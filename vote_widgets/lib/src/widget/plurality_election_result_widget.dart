import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote/vote.dart';

import '../../helpers.dart';
import '../model/candidate.dart';

class const PluralityElectionResultWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<PluralityElection<Candidate>>(
    builder: (context, value, _) =>
        _PluralityTableHelper(value.places).build(context),
  );
}

class const _PluralityTableHelper(
  @override final List<PluralityElectionPlace<Candidate>> places,
) extends TableHelper<PluralityElectionPlace<Candidate>> {
  @override
  List<Object> get columns => const ['Place', Icons.person, 'Votes'];

  @override
  String textForColumn(
    int columnName,
    PluralityElectionPlace<Candidate> entry,
  ) => columnName == 2
      ? entry.voteCount.toString()
      : super.textForColumn(columnName, entry);
}
