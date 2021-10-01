import 'package:flutter/widgets.dart';

abstract class VoteNotification extends Notification {
  const VoteNotification();
}

@immutable
class CandidateHoverNotification<T> extends VoteNotification {
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
}

@immutable
class CandidatePairHoverNotification<T> extends VoteNotification {
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
