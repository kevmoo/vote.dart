import 'package:meta/meta.dart';

@immutable
class Ballot<TVoter> {
  final TVoter voter;

  const Ballot(this.voter);

  @override
  bool operator ==(Object other) => other is Ballot && other.voter == voter;

  @override
  int get hashCode => voter.hashCode;
}
