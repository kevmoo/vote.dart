import 'package:meta/meta.dart';

@immutable
abstract class Ballot<TVoter, TCandidate> {
  final TVoter voter;

  const Ballot(this.voter);

  Iterable<TCandidate> referencedCandidates();

  @override
  bool operator ==(Object other) => other is Ballot && other.voter == voter;

  @override
  int get hashCode => voter.hashCode;
}
