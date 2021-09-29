import 'package:flutter/material.dart';

class TooSmallWidget extends StatefulWidget {
  final Size minimumSize;
  final Widget child;
  const TooSmallWidget({
    Key? key,
    required this.minimumSize,
    required this.child,
  }) : super(key: key);

  @override
  _TooSmallWidgetState createState() => _TooSmallWidgetState();
}

class _TooSmallWidgetState extends State<TooSmallWidget> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (!_dismissed && _tooSmall(constraints)) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                widget.child,
                Card(
                  margin: const EdgeInsets.all(15),
                  elevation: 10,
                  color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'This app works much better on a bigger screen. '
                              'Try it on a desktop or laptop.',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _dismiss,
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          return widget.child;
        },
      );

  bool _tooSmall(BoxConstraints constraints) =>
      constraints.maxWidth < widget.minimumSize.width ||
      constraints.maxHeight < widget.minimumSize.height;

  void _dismiss() {
    if (!_dismissed) {
      setState(() {
        _dismissed = true;
      });
    }
  }
}
