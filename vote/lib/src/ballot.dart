import 'package:meta/meta.dart';

@immutable
abstract class Ballot<TCandidate extends Comparable> {
  const Ballot();

  Iterable<TCandidate> referencedCandidates();
}
