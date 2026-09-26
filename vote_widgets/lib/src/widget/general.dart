import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NotificationNotifier<T extends Notification>._()
    extends ChangeNotifier
    implements ValueListenable<T?> {
  @override
  T? get value => _value;
  T? _value;

  void _setValue(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }
}

class const NotificationMirror<T extends Notification>({
  super.key,
  required final Widget child,
  T? Function(T)? transform,
}) extends StatefulWidget {
  final T? Function(T) transform = transform ?? identityTransform;

  @override
  State createState() => _NotificationMirrorState<T>();

  static T? identityTransform<T>(T? input) => input;
}

class _NotificationMirrorState<T extends Notification>()
    extends State<NotificationMirror<T>> {
  final _notifier = NotificationNotifier<T>._();

  bool _onNotification(T notification) {
    _notifier._setValue(widget.transform(notification));

    return true;
  }

  @override
  Widget build(BuildContext context) => NotificationListener<T>(
    onNotification: _onNotification,
    child: ValueListenableProvider.value(value: _notifier, child: widget.child),
  );
}
