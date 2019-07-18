import 'package:vote/vote.dart';

import 'candidate.dart';
import 'voter.dart';

abstract class ElectionData {
  List<Candidate> get candidates;

  CondorcetElection<Voter, Candidate> get condorcetElection;

  IrvElection<Voter, Candidate> get irvElection;

  PluralityElection<Voter, Candidate> get pluralityElection;
}
