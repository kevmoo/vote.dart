import 'package:flutter/widgets.dart';

abstract class VoteNotification<T> extends Notification {
  bool get stop;
  const VoteNotification();

  /// Returns `true` if `this` refers to [candidate] in some way.
  bool relatedTo(T candidate);
}

@immutable
class CandidateHoverNotification<T> extends VoteNotification<T> {
  @override
  final bool stop;
  final T candidate;

  const CandidateHoverNotification(this.candidate, {this.stop = false});

  static VoteNotification create<T>(
    T candidate, {
    T? otherCandidate,
    bool stop = false,
  }) =>
      otherCandidate == null
          ? CandidateHoverNotification(candidate, stop: stop)
          : CandidatePairHoverNotification(
              candidate,
              otherCandidate,
              stop: stop,
            );

  @override
  String toString() =>
      'CandidateHoverNotification($candidate${stop ? ' [stop]' : ''})';

  @override
  bool operator ==(Object other) =>
      other is CandidateHoverNotification<T> &&
      other.stop == stop &&
      other.candidate == candidate;

  @override
  int get hashCode => Object.hash(stop, candidate);

  @override
  bool relatedTo(T candidate) => candidate == this.candidate;
}

@immutable
class CandidatePairHoverNotification<T> extends VoteNotification<T> {
  @override
  final bool stop;
  final T candidateA, candidateB;

  const CandidatePairHoverNotification(
    this.candidateA,
    this.candidateB, {
    this.stop = false,
  });

  @override
  String toString() => 'CandidatePairHoverNotification'
      '($candidateA,$candidateB${stop ? ' [stop]' : ''})';

  @override
  bool operator ==(Object other) =>
      other is CandidatePairHoverNotification<T> &&
      other.stop == stop &&
      other.candidateA == candidateA &&
      other.candidateB == candidateB;

  @override
  int get hashCode => Object.hash(stop, candidateA, candidateB);

  @override
  bool relatedTo(T candidate) =>
      candidateA == candidate || candidateB == candidate;
}

class CandidateHoverWidget<T> extends StatelessWidget {
  final T candidate;
  final T? otherCandidate;
  final Widget child;
  const CandidateHoverWidget({
    Key? key,
    required this.candidate,
    required this.child,
    this.otherCandidate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (event) => CandidateHoverNotification.create(
          candidate,
          otherCandidate: otherCandidate,
        ).dispatch(context),
        onExit: (event) => CandidateHoverNotification.create(
          candidate,
          otherCandidate: otherCandidate,
          stop: true,
        ).dispatch(context),
        onHover: (event) => CandidateHoverNotification.create(
          candidate,
          otherCandidate: otherCandidate,
        ).dispatch(context),
        child: child,
      );
}
