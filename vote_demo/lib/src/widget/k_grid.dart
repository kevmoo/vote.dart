import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class KGrid extends MultiChildRenderObjectWidget {
  final double maxCrossAxisExtent;

  KGrid({
    Key? key,
    required this.maxCrossAxisExtent,
    List<Widget> children = const <Widget>[],
  })  : assert(maxCrossAxisExtent > 0),
        super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) => _KGrid(this);
}

class _KGridParentData extends ContainerBoxParentData<RenderBox> {}

class _KGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _KGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _KGridParentData> {
  _KGrid(this._kStackParent);

  final KGrid _kStackParent;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _KGridParentData) {
      child.parentData = _KGridParentData();
    }
  }

  @override
  void performLayout() {
    var mainAxisExtent = 0.0;

    final columnCount = math.max(
      1,
      constraints.maxWidth ~/ _kStackParent.maxCrossAxisExtent,
    );

    final columnWidth =
        math.min(_kStackParent.maxCrossAxisExtent, constraints.maxWidth);
    final innerConstraints = BoxConstraints.tightFor(width: columnWidth);

    var child = firstChild;
    while (child != null) {
      var rowExtent = 0.0;

      for (var currentColumn = 0;
          currentColumn < columnCount && child != null;
          currentColumn++) {
        child.layout(innerConstraints, parentUsesSize: true);
        final childParentData = (child.parentData as _KGridParentData)
          ..offset = Offset(currentColumn * columnWidth, mainAxisExtent);

        rowExtent = math.max(rowExtent, child.size.height);

        child = childParentData.nextSibling;
      }
      mainAxisExtent += rowExtent;
    }

    size = constraints.constrain(
      Size(
        columnCount * columnWidth,
        mainAxisExtent,
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(
    BoxHitTestResult result, {
    required Offset position,
  }) =>
      defaultHitTestChildren(result, position: position);
}
