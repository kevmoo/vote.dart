import 'package:meta/meta.dart';

/// Baseclass for all data types representing a ballot.
@immutable
abstract class Ballot<TCandidate extends Comparable> {
  const Ballot();

  /// All candidates referenced by this ballot.
  ///
  /// Will contain at least one value in all election types.
  Iterable<TCandidate> referencedCandidates();
}
