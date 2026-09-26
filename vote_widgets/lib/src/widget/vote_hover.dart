import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers.dart';

abstract class const VoteNotification<T>() extends Notification {
  bool get stop;

  /// Returns `true` if `this` refers to [candidate] in some way.
  bool relatedTo(T candidate);
}

@immutable
class const CandidateSetHoverNotification<T>(
  final Set<T> candidates, {
  @override final bool stop = false,
}) extends VoteNotification<T> {
  @override
  String toString() =>
      'CandidatePairHoverNotification'
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

class const CandidateHoverWidget<T>({
  super.key,
  required final Set<T> candidates,
  required final Widget child,
}) extends StatelessWidget {
  bool _matches(VoteNotification<dynamic>? data) =>
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
    child: Consumer<VoteNotification<dynamic>?>(
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
