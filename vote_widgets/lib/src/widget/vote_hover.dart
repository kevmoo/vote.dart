import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers.dart';

abstract class VoteNotification<T> extends Notification {
  bool get stop;
  const VoteNotification();

  /// Returns `true` if `this` refers to [candidate] in some way.
  bool relatedTo(T candidate);
}

@immutable
class CandidateSetHoverNotification<T> extends VoteNotification<T> {
  @override
  final bool stop;
  final Set<T> candidates;

  const CandidateSetHoverNotification(
    this.candidates, {
    this.stop = false,
  });

  @override
  String toString() => 'CandidatePairHoverNotification'
      '($candidates ${stop ? ' [stop]' : ''})';

  @override
  bool operator ==(Object other) =>
      other is CandidateSetHoverNotification<T> &&
      other.stop == stop &&
      candidates.sameItems(other.candidates);

  @override
  int get hashCode => Object.hash(stop, Object.hashAll(candidates));

  @override
  bool relatedTo(T candidate) => candidates.contains(candidate);
}

class CandidateHoverWidget<T> extends StatelessWidget {
  final Set<T> candidates;
  final Widget child;
  const CandidateHoverWidget({
    Key? key,
    required this.candidates,
    required this.child,
  }) : super(key: key);

  bool _matches(VoteNotification? data) =>
      data is CandidateSetHoverNotification<T> &&
      candidates.sameItems(data.candidates);

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (event) =>
            CandidateSetHoverNotification<T>(candidates).dispatch(context),
        onExit: (event) => CandidateSetHoverNotification<T>(
          candidates,
          stop: true,
        ).dispatch(context),
        onHover: (event) =>
            CandidateSetHoverNotification<T>(candidates).dispatch(context),
        child: Consumer<VoteNotification?>(
          builder: (context, value, _) => DefaultTextStyle(
            style: TextStyle(
              color: Colors.black,
              fontWeight: _matches(value) ? FontWeight.w900 : null,
            ),
            child: child,
          ),
        ),
      );
}
