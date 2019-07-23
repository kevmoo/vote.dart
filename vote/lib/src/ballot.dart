import 'package:meta/meta.dart';

@immutable
abstract class Ballot<TCandidate> {
  const Ballot();

  Iterable<TCandidate> referencedCandidates();
}
