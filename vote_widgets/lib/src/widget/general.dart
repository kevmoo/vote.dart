import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NotificationNotifier<T extends Notification> extends ChangeNotifier
    implements ValueListenable<T?> {
  NotificationNotifier._();

  @override
  T? get value => _value;
  T? _value;

  void _setValue(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }
}

class NotificationMirror<T extends Notification> extends StatefulWidget {
  final Widget child;

  final T? Function(T) transform;

  const NotificationMirror({
    Key? key,
    required this.child,
    T? Function(T)? transform,
  })  : transform = transform ?? identityTransform,
        super(key: key);

  @override
  _NotificationMirrorState<T> createState() => _NotificationMirrorState<T>();

  static T? identityTransform<T>(T? input) => input;
}

class _NotificationMirrorState<T extends Notification>
    extends State<NotificationMirror<T>> {
  final _notifier = NotificationNotifier<T>._();

  bool _onNotification(T notification) {
    _notifier._setValue(widget.transform(notification));

    return true;
  }

  @override
  Widget build(BuildContext context) => NotificationListener<T>(
        onNotification: _onNotification,
        child: ValueListenableProvider.value(
          value: _notifier,
          child: widget.child,
        ),
      );
}
