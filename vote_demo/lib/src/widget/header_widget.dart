import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  final String header;
  final Widget child;
  final Object? extraHelp;

  const HeaderWidget({
    Key? key,
    required this.header,
    required this.child,
    this.extraHelp,
  }) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  ScaffoldFeatureController? _snackbarController;

  @override
  void dispose() {
    _closeSnackbarIfOpen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Flexible(child: Container()),
                Expanded(
                  flex: 6,
                  child: Text(
                    widget.header,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: widget.extraHelp == null
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: _snackHandler(context),
                          ),
                  ),
                )
              ],
            ),
            widget.child,
          ],
        ),
      );

  Widget _extraHelpContent() {
    final extraHelp = widget.extraHelp!;
    if (extraHelp is String) {
      return SelectableText(extraHelp, textScaleFactor: 1.4);
    }

    if (extraHelp is TextSpan) {
      return SelectableText.rich(extraHelp, textScaleFactor: 1.4);
    }

    return Text('??? $extraHelp ???');
  }

  void Function() _snackHandler(BuildContext context) => () {
        final messenger = ScaffoldMessenger.of(context);

        if (_closeSnackbarIfOpen()) {
          return;
        }

        final snackBar = SnackBar(
          duration: const Duration(seconds: 10),
          content: _extraHelpContent(),
          action: SnackBarAction(
            label: 'Close',
            onPressed: _closeSnackbarIfOpen,
          ),
        );

        messenger.clearSnackBars();

        _snackbarController = messenger.showSnackBar(snackBar);
        _snackbarController!.closed.then((value) {
          _snackbarController = null;
        });
      };

  bool _closeSnackbarIfOpen() {
    final controller = _snackbarController;
    if (controller != null) {
      // still open!
      controller.close();
      _snackbarController = null;
      return true;
    }
    return false;
  }
}
