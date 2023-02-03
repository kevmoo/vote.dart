// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Copied (and then modified) with appreciation from
// https://github.com/tvolkert/chicago/blob/master/lib/src/table_pane.dart
// at https://github.com/tvolkert/chicago/commit/8438209727527a6679a7f6a6695286e

// ignore_for_file: require_trailing_commas

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef _IntrinsicComputer = double Function(
    RenderBox child, double crossAxisConstraint);

double _sum(double a, double b) => a + b;

class TablePaneColumn with Diagnosticable {
  const TablePaneColumn({
    this.width = const RelativeTablePaneColumnWidth(),
  });

  final TablePaneColumnWidth width;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TablePaneColumnWidth>('width', width));
  }
}

abstract class TablePaneColumnWidth with Diagnosticable {
  const TablePaneColumnWidth._();

  @protected
  double get width;

  @protected
  bool get isRelative;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('width', width))
      ..add(DiagnosticsProperty<bool>('isRelative', isRelative));
  }
}

class IntrinsicTablePaneColumnWidth extends TablePaneColumnWidth {
  const IntrinsicTablePaneColumnWidth([this.mainAxisSize = MainAxisSize.max])
      : super._();

  final MainAxisSize mainAxisSize;

  @override
  @protected
  double get width => -1;

  @override
  @protected
  bool get isRelative => false;
}

class FixedTablePaneColumnWidth extends TablePaneColumnWidth {
  const FixedTablePaneColumnWidth(this.width)
      : assert(width >= 0),
        super._();

  @override
  @protected
  final double width;

  @override
  @protected
  bool get isRelative => false;
}

class RelativeTablePaneColumnWidth extends TablePaneColumnWidth {
  const RelativeTablePaneColumnWidth({this.weight = 1}) : super._();

  final double weight;

  @override
  @protected
  double get width => weight;

  @override
  @protected
  bool get isRelative => true;
}

abstract class TablePaneRowHeight {
  const TablePaneRowHeight._();

  @protected
  double get height;

  @protected
  bool get isRelative;
}

class IntrinsicTablePaneRowHeight extends TablePaneRowHeight {
  const IntrinsicTablePaneRowHeight([this.mainAxisSize = MainAxisSize.max])
      : super._();

  final MainAxisSize mainAxisSize;

  @override
  @protected
  double get height => -1;

  @override
  @protected
  bool get isRelative => false;
}

class FixedTablePaneRowHeight extends TablePaneRowHeight {
  const FixedTablePaneRowHeight(this.height)
      : assert(height >= 0),
        super._();

  @override
  @protected
  final double height;

  @override
  @protected
  bool get isRelative => false;
}

class RelativeTablePaneRowHeight extends TablePaneRowHeight {
  const RelativeTablePaneRowHeight({this.weight = 1}) : super._();

  final double weight;

  @override
  @protected
  double get height => weight;

  @override
  @protected
  bool get isRelative => true;
}

class TableCell extends ParentDataWidget<TableCellParentData> {
  /// Creates a widget that controls the row-span and column-span of a child of
  /// [TablePane].
  const TableCell({
    super.key,
    this.rowSpan = 1,
    this.columnSpan = 1,
    required super.child,
  })  : assert(rowSpan > 0),
        assert(columnSpan > 0);

  /// The number of rows this cell occupies.
  final int rowSpan;

  /// The number of columns this cell occupies.
  final int columnSpan;

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as TableCellParentData;
    if (parentData.rowSpan != rowSpan || parentData.columnSpan != columnSpan) {
      parentData
        ..rowSpan = rowSpan
        ..columnSpan = columnSpan;
      var targetParent = renderObject.parent;
      while (targetParent != null && targetParent is! _RenderTablePane) {
        targetParent = targetParent.parent;
      }
      if (targetParent is _RenderTablePane) {
        targetParent.markNeedsMetrics();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => TableRow;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('rowSpan', rowSpan))
      ..add(IntProperty('columnSpan', columnSpan));
  }
}

class EmptyTableCell extends LeafRenderObjectWidget {
  const EmptyTableCell({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderEmptyTableCell();
}

/// TablePane's layout is "width in, height out", meaning it will compute its
/// column widths first with unconstrained height, then compute the row heights
/// using those column widths as the width constraints.
class TablePane extends MultiChildRenderObjectWidget {
  const TablePane({
    super.key,
    required this.columns,
    this.horizontalSpacing = 0,
    this.verticalSpacing = 0,
    this.horizontalIntrinsicSize = MainAxisSize.max,
    this.horizontalRelativeSize = MainAxisSize.max,
    this.verticalIntrinsicSize = MainAxisSize.max,
    this.verticalRelativeSize = MainAxisSize.max,
    this.metricsController,
    required super.children,
  });

  final List<TablePaneColumn> columns;
  final double horizontalSpacing;
  final double verticalSpacing;
  final MainAxisSize horizontalIntrinsicSize;
  final MainAxisSize horizontalRelativeSize;
  final MainAxisSize verticalIntrinsicSize;
  final MainAxisSize verticalRelativeSize;
  final TablePaneMetricsController? metricsController;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderTablePane(
        columns: columns,
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing,
        horizontalIntrinsicSize: horizontalIntrinsicSize,
        horizontalRelativeSize: horizontalRelativeSize,
        verticalIntrinsicSize: verticalIntrinsicSize,
        verticalRelativeSize: verticalRelativeSize,
        metricsController: metricsController,
      );

  @override
  // ignore: library_private_types_in_public_api
  void updateRenderObject(BuildContext context, _RenderTablePane renderObject) {
    renderObject
      ..columns = columns
      ..horizontalSpacing = horizontalSpacing
      ..verticalSpacing = verticalSpacing
      ..horizontalIntrinsicSize = horizontalIntrinsicSize
      ..horizontalRelativeSize = horizontalRelativeSize
      ..verticalIntrinsicSize = verticalIntrinsicSize
      ..verticalRelativeSize = verticalRelativeSize
      ..metricsController = metricsController;
  }
}

class TableRow extends MultiChildRenderObjectWidget {
  const TableRow({
    super.key,
    this.height = const IntrinsicTablePaneRowHeight(),
    this.backgroundColor,
    required super.children,
  });

  final TablePaneRowHeight height;
  final Color? backgroundColor;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderTableRow(
        height: height,
        backgroundColor: backgroundColor,
      );

  @override
  // ignore: library_private_types_in_public_api
  void updateRenderObject(BuildContext context, _RenderTableRow renderObject) {
    renderObject
      ..height = height
      ..backgroundColor = backgroundColor;
  }
}

/// [ParentData] used by [_RenderTablePane].
class TableRowParentData extends ContainerBoxParentData<_RenderTableRow> {}

/// [ParentData] used by [_RenderTableRow].
class TableCellParentData extends ContainerBoxParentData<RenderBox> {
  /// The column that the child was in the last time it was laid out.
  int? x;

  int _rowSpan = 1;
  int get rowSpan => _rowSpan;
  set rowSpan(int value) {
    assert(value > 0);
    _rowSpan = value;
  }

  int _columnSpan = 1;
  int get columnSpan => _columnSpan;
  set columnSpan(int value) {
    assert(value > 0);
    _columnSpan = value;
  }

  @override
  String toString() =>
      '${super.toString()}; $rowSpan rows x $columnSpan columns';
}

class TableRowConstraints extends BoxConstraints {
  const TableRowConstraints.tightFor({
    super.width,
    super.height,
    required this.cellConstraints,
    required this.cellPositions,
  }) : super.tightFor();

  final List<BoxConstraints> cellConstraints;
  final List<Offset> cellPositions;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TableRowConstraints &&
        super == other &&
        const ListEquality<Object>()
            .equals(other.cellConstraints, cellConstraints) &&
        const ListEquality<Object>().equals(other.cellPositions, cellPositions);
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return Object.hash(
      super.hashCode,
      Object.hashAll(cellConstraints),
      Object.hashAll(cellPositions),
    );
  }

  @override
  String toString() => 'TableRowConstraints(base=${super.toString()}, '
      'cellConstraints=$cellConstraints), '
      'cellPositions=$cellPositions';
}

class _RenderEmptyTableCell extends RenderBox {
  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.smallest;
}

mixin _ChildListRenderObjectMixin<ChildType extends RenderBox,
        ParentDataType extends ContainerBoxParentData<ChildType>>
    on RenderBoxContainerDefaultsMixin<ChildType, ParentDataType> {
  List<RenderBox>? _children;

  @protected
  List<RenderBox> get children => _children ??= getChildrenAsList();

  @protected
  @mustCallSuper
  void markNeedsChildren() {
    _children = null;
  }

  /// The number of children belonging to this render object.
  int get length => childCount;

  /// Gets the child at the specified index.
  RenderBox operator [](int index) => children[index];

  @override
  void insert(RenderBox child, {RenderBox? after}) {
    super.insert(child as ChildType, after: after as ChildType?);
    markNeedsChildren();
  }

  @override
  void remove(RenderBox child) {
    super.remove(child as ChildType);
    markNeedsChildren();
  }

  @override
  void removeAll() {
    super.removeAll();
    markNeedsChildren();
  }

  @override
  void move(RenderBox child, {RenderBox? after}) {
    super.move(child as ChildType, after: after as ChildType?);
    markNeedsChildren();
  }
}

class _RenderTableRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TableCellParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TableCellParentData>,
        _ChildListRenderObjectMixin<RenderBox, TableCellParentData> {
  _RenderTableRow({
    required TablePaneRowHeight height,
    Color? backgroundColor,
  }) {
    this.height = height;
    this.backgroundColor = backgroundColor;
  }

  TablePaneRowHeight _height = const IntrinsicTablePaneRowHeight();
  TablePaneRowHeight get height => _height;
  set height(TablePaneRowHeight value) {
    if (value != _height) {
      _height = value;
      markNeedsLayout();
      if (parent != null) {
        parent!.markNeedsMetrics();
      }
    }
  }

  Color? _backgroundColor;
  Color? get backgroundColor => _backgroundColor;
  set backgroundColor(Color? value) {
    if (value != _backgroundColor) {
      _backgroundColor = value;
      markNeedsPaint();
    }
  }

  @override
  TableRowConstraints get constraints =>
      super.constraints as TableRowConstraints;

  @override
  _RenderTablePane? get parent => super.parent as _RenderTablePane?;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TableCellParentData) {
      child.parentData = TableCellParentData();
    }
  }

  @override
  @protected
  void markNeedsChildren() {
    super.markNeedsChildren();
    parent!.markNeedsMetrics();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void markNeedsLayout() {
    final parent = this.parent;
    if (parent != null) {
      parent.markNeedsMetrics();
      markParentNeedsLayout();
      return;
    }
    super.markNeedsLayout();
  }

  @override
  void performLayout() {
    // RenderTablePane will always give us tight constraints
    assert(constraints.isTight);
    size = constraints.smallest;

    for (var i = 0; i < length; i++) {
      final child = this[i];
      final childParentData = child.parentData as BoxParentData;
      child.layout(constraints.cellConstraints[i]);
      childParentData.offset = constraints.cellPositions[i];
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (backgroundColor != null) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = backgroundColor!;
      context.canvas.drawRect(offset & size, paint);
    }
    defaultPaint(context, offset);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TablePaneRowHeight>('height', height));
  }
}

class _RenderTablePane extends RenderBox
    with
        ContainerRenderObjectMixin<_RenderTableRow, TableRowParentData>,
        RenderBoxContainerDefaultsMixin<_RenderTableRow, TableRowParentData>,
        _ChildListRenderObjectMixin<_RenderTableRow, TableRowParentData> {
  _RenderTablePane({
    required List<TablePaneColumn> columns,
    double horizontalSpacing = 0,
    double verticalSpacing = 0,
    MainAxisSize horizontalIntrinsicSize = MainAxisSize.max,
    MainAxisSize horizontalRelativeSize = MainAxisSize.max,
    MainAxisSize verticalIntrinsicSize = MainAxisSize.max,
    MainAxisSize verticalRelativeSize = MainAxisSize.max,
    TablePaneMetricsController? metricsController,
  }) {
    this.columns = columns;
    this.horizontalSpacing = horizontalSpacing;
    this.verticalSpacing = verticalSpacing;
    this.horizontalIntrinsicSize = horizontalIntrinsicSize;
    this.horizontalRelativeSize = horizontalRelativeSize;
    this.verticalIntrinsicSize = verticalIntrinsicSize;
    this.verticalRelativeSize = verticalRelativeSize;
    this.metricsController = metricsController;
  }

  List<TablePaneColumn> _columns = const <TablePaneColumn>[];
  List<TablePaneColumn> get columns => _columns;
  set columns(List<TablePaneColumn> value) {
    if (!const ListEquality<Object>().equals(value, _columns)) {
      _columns = value;
      markNeedsMetrics();
    }
  }

  double _horizontalSpacing = 0;
  double get horizontalSpacing => _horizontalSpacing;
  set horizontalSpacing(double value) {
    if (value != _horizontalSpacing) {
      _horizontalSpacing = value;
      markNeedsMetrics();
    }
  }

  double _verticalSpacing = 0;
  double get verticalSpacing => _verticalSpacing;
  set verticalSpacing(double value) {
    if (value != _verticalSpacing) {
      _verticalSpacing = value;
      markNeedsMetrics();
    }
  }

  MainAxisSize _horizontalIntrinsicSize = MainAxisSize.max;
  MainAxisSize get horizontalIntrinsicSize => _horizontalIntrinsicSize;
  set horizontalIntrinsicSize(MainAxisSize value) {
    if (value != _horizontalIntrinsicSize) {
      _horizontalIntrinsicSize = value;
      markNeedsMetrics();
    }
  }

  MainAxisSize _horizontalRelativeSize = MainAxisSize.max;
  MainAxisSize get horizontalRelativeSize => _horizontalRelativeSize;
  set horizontalRelativeSize(MainAxisSize value) {
    if (value != _horizontalRelativeSize) {
      _horizontalRelativeSize = value;
      markNeedsMetrics();
    }
  }

  MainAxisSize _verticalIntrinsicSize = MainAxisSize.max;
  MainAxisSize get verticalIntrinsicSize => _verticalIntrinsicSize;
  set verticalIntrinsicSize(MainAxisSize value) {
    if (value != _verticalIntrinsicSize) {
      _verticalIntrinsicSize = value;
      markNeedsMetrics();
    }
  }

  MainAxisSize _verticalRelativeSize = MainAxisSize.max;
  MainAxisSize get verticalRelativeSize => _verticalRelativeSize;
  set verticalRelativeSize(MainAxisSize value) {
    if (value != _verticalRelativeSize) {
      _verticalRelativeSize = value;
      markNeedsMetrics();
    }
  }

  TablePaneMetricsController? _metricsController;
  TablePaneMetricsController? get metricsController => _metricsController;
  set metricsController(TablePaneMetricsController? value) {
    if (value != _metricsController) {
      if (_metricsController != null && attached) {
        _metricsController!._detach();
      }
      _metricsController = value;
      if (value != null && attached) {
        value._attach(this);
      }
    }
  }

  /// Computes the intrinsic height of a table pane row, which is defined as
  /// the maximum intrinsic height of the row's cells.
  ///
  /// Because their intrinsic height relates to the intrinsic heights of other
  /// rows, cells that span multiple rows will not be considered in this
  /// calculation (even if they live in the row directly). It is up to the
  /// caller to factor such cells into the row heights calculation.
  double _computeIntrinsicRowHeight(
    int rowIndex,
    List<double> columnWidths,
    _IntrinsicComputer computeIntrinsicCellHeight,
  ) {
    assert(rowIndex >= 0 && rowIndex < rows.length);
    final row = rows[rowIndex];
    var result = 0.0;
    final n = row.length, m = columns.length;
    for (var j = 0; j < n && j < m; j++) {
      final child = row[j];
      final childParentData = child.parentData as TableCellParentData;
      if (childParentData.rowSpan == 1) {
        result = math.max(
            result, computeIntrinsicCellHeight(child, columnWidths[j]));
      }
    }
    return result;
  }

  /// Gets the intrinsic width of a table pane column, which is defined as the
  /// maximum intrinsic width of the column's cells.
  ///
  /// Because their intrinsic width relates to the intrinsic widths of other
  /// columns, cells that span multiple columns will not be considered in
  /// this calculation (even if they live in the column directly). It is up to
  /// the caller to factor such cells into the column widths calculation.
  double _computeIntrinsicColumnWidth(
    int columnIndex,
    _IntrinsicComputer computeIntrinsicCellWidth,
  ) {
    var result = 0.0;
    final n = rows.length;
    for (var i = 0; i < n; i++) {
      final row = rows[i];
      if (columnIndex < row.length) {
        final child = row[columnIndex];
        final childParentData = child.parentData as TableCellParentData;
        if (childParentData.columnSpan == 1) {
          result = math.max(
              result, computeIntrinsicCellWidth(child, double.infinity));
        }
      }
    }
    return result;
  }

  List<double> _computeIntrinsicRowHeights(
    double width,
    _IntrinsicComputer computeIntrinsicCellHeight,
  ) {
    assert(!width.isNegative);
    final rowHeights = List<double>.filled(rows.length, 0);
    final relativeWeights = List<double>.filled(rows.length, 0);
    final intrinsicHeightRows = List<bool>.filled(rows.length, false);
    final columnWidths = width.isFinite
        ? _computeActualColumnWidths(_LinearConstraints.tight(width))
        : _computeIntrinsicColumnWidths(_computeIntrinsicChildWidth);

    // First, we calculate the base heights of the rows, giving relative
    // rows their intrinsic height. Spanning cells will be ignored in this
    // pass.
    var totalRelativeWeight = 0.0;
    for (var i = 0; i < rows.length; i++) {
      final heightSpec = rows[i].height;
      final rowHeight = heightSpec.height;
      final isRelative = heightSpec.isRelative;
      final isIntrinsic = intrinsicHeightRows[i] = rowHeight < 0;

      if (isRelative) {
        relativeWeights[i] = rowHeight;
        totalRelativeWeight += rowHeight;
      }

      if (isIntrinsic || isRelative) {
        rowHeights[i] = _computeIntrinsicRowHeight(
            i, columnWidths, computeIntrinsicCellHeight);
      } else {
        rowHeights[i] = rowHeight;
      }
    }

    // Next, we account for spanning cells, which have been ignored thus
    // far. If any spanned cell is intrinsic-height (including relative height
    // rows), then we ensure that the sum of the heights of the spanned cells
    // is enough to satisfy the intrinsic height of the spanning content.
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final n = row.length, m = columns.length;
      for (var j = 0; j < n && j < m; j++) {
        final child = row[j];

        if (child is! _RenderEmptyTableCell) {
          final childParentData = child.parentData as TableCellParentData;
          final rowSpan = childParentData.rowSpan;

          if (rowSpan > 1) {
            // We might need to adjust row heights to accommodate this spanning
            // cell. First, we find out if any of the spanned cells are
            // intrinsic height or relative height and how much space we've
            // allocated thus far for those cells.
            var spannedIntrinsicHeightCellCount = 0;
            var spannedRelativeWeight = 0.0;
            var spannedHeight = 0.0;
            for (var k = 0; k < rowSpan && i + k < rows.length; k++) {
              spannedRelativeWeight += relativeWeights[i + k];
              spannedHeight += rowHeights[i + k];
              if (intrinsicHeightRows[i + k]) {
                spannedIntrinsicHeightCellCount++;
              }
            }

            if (spannedRelativeWeight > 0 ||
                spannedIntrinsicHeightCellCount > 0) {
              final columnSpan = childParentData.columnSpan;
              var childWidth =
                  columnWidths.skip(j).take(columnSpan).fold<double>(0, _sum);
              childWidth += math.max(columnSpan - 1, 0) * horizontalSpacing;
              final childIntrinsicHeight =
                  computeIntrinsicCellHeight(child, childWidth);

              if (childIntrinsicHeight > spannedHeight) {
                // The child's intrinsic height is larger than the height we've
                // allocated thus far, so an adjustment is necessary.
                final adjustment = childIntrinsicHeight - spannedHeight;

                if (spannedRelativeWeight > 0) {
                  // We'll distribute the adjustment across the spanned
                  // relative rows and adjust other relative row heights to
                  // keep all relative row heights reconciled.
                  final unitAdjustment = adjustment / spannedRelativeWeight;
                  for (var k = 0; k < rowSpan && i + k < rows.length; k++) {
                    final relativeWeight = relativeWeights[i + k];
                    if (relativeWeight > 0) {
                      final rowAdjustment = unitAdjustment * relativeWeight;
                      rowHeights[i + k] += rowAdjustment;
                    }
                  }
                } else {
                  // We'll distribute the adjustment evenly among the
                  // intrinsic-height rows.
                  for (var k = 0; k < rowSpan && i + k < rows.length; k++) {
                    if (intrinsicHeightRows[i + k]) {
                      final rowAdjustment =
                          adjustment / spannedIntrinsicHeightCellCount;
                      rowHeights[i + k] += rowAdjustment;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // Finally, we adjust the heights of the relative rows upwards where
    // necessary to reconcile their heights relative to one another while
    // ensuring that they still get at least their intrinsic height.
    if (totalRelativeWeight > 0) {
      // Calculate total relative height after the required upward adjustments
      var totalRelativeHeight = 0.0;
      for (var i = 0; i < rows.length; i++) {
        final relativeWeight = relativeWeights[i];
        if (relativeWeight > 0) {
          final rowHeight = rowHeights[i];
          final weightPercentage = relativeWeight / totalRelativeWeight;
          totalRelativeHeight =
              math.max(totalRelativeHeight, rowHeight / weightPercentage);
        }
      }

      // Perform the upward adjustments using the total relative height
      for (var i = 0; i < rows.length; i++) {
        final relativeWeight = relativeWeights[i];
        if (relativeWeight > 0) {
          final weightPercentage = relativeWeight / totalRelativeWeight;
          rowHeights[i] = weightPercentage * totalRelativeHeight;
        }
      }
    }

    return rowHeights;
  }

  List<double> _computeActualRowHeights(
    _LinearConstraints heightConstraints,
    List<double> columnWidths,
  ) {
    final totalRelativeWeight = rows
        .map<TablePaneRowHeight>((_RenderTableRow row) => row.height)
        .whereType<RelativeTablePaneRowHeight>()
        .map<double>(
            (RelativeTablePaneRowHeight heightSpec) => heightSpec.height)
        .fold<double>(0, _sum);

    final totalWidth = _computeWidth(columnWidths);
    final rowHeights =
        _computeIntrinsicRowHeights(totalWidth, _computeIntrinsicChildHeight);
    var totalHeight = _computeHeight(rowHeights);

    void growRelativeRowsToMeetMinimumTotalHeight(double minimumHeight) {
      final remainingHeight = minimumHeight - totalHeight;
      assert(remainingHeight >= 0);
      for (var i = 0; i < rows.length; i++) {
        final rowHeightSpec = rows[i].height;
        if (rowHeightSpec.isRelative) {
          final relativeWeight = rowHeightSpec.height;
          final weightPercentage = relativeWeight / totalRelativeWeight;
          assert(weightPercentage > 0 && weightPercentage <= 1);
          final addHeight = remainingHeight * weightPercentage;
          rowHeights[i] += addHeight;
          totalHeight += addHeight;
        }
      }
    }

    if (heightConstraints.isSatisfiedBy(totalHeight)) {
      if (verticalRelativeSize == MainAxisSize.max &&
          heightConstraints.isBounded &&
          totalRelativeWeight > 0) {
        // Grow the relative-height rows to fill the max height constraint.
        growRelativeRowsToMeetMinimumTotalHeight(heightConstraints.max);
      }
    } else if (heightConstraints < totalHeight) {
      if (totalRelativeWeight > 0) {
        // Shrink the relative-height rows to meet the max height constraints.
        final overflowHeight = totalHeight - heightConstraints.max;
        assert(overflowHeight >= 0);
        bool? excessiveOverflow;
        for (var i = 0; i < rows.length; i++) {
          final rowHeightSpec = rows[i].height;
          if (rowHeightSpec.isRelative) {
            final relativeWeight = rowHeightSpec.height;
            final weightPercentage = relativeWeight / totalRelativeWeight;
            assert(weightPercentage > 0 && weightPercentage <= 1);
            var subtractHeight = overflowHeight * weightPercentage;
            final localOverflow = subtractHeight > rowHeights[i];
            assert(excessiveOverflow == null ||
                excessiveOverflow == localOverflow);
            excessiveOverflow = (excessiveOverflow ?? false) || localOverflow;
            if (excessiveOverflow) {
              subtractHeight = rowHeights[i];
            }
            rowHeights[i] -= subtractHeight;
            totalHeight -= subtractHeight;
          }
        }
        assert(excessiveOverflow == (heightConstraints < totalHeight));
        if (excessiveOverflow!) {
          // TODO: handle overflow
        }
      } else {
        // TODO: handle overflow
      }
    } else if (heightConstraints > totalHeight) {
      if (totalRelativeWeight > 0) {
        // Grow the relative-height rows to meet the min height constraints.
        growRelativeRowsToMeetMinimumTotalHeight(heightConstraints.min);
      }
    }

    assert(() {
      if (rowHeights.any((double value) => value.isNegative)) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('RenderTablePane computed a negative-height row.'),
          ErrorDescription('This indicates a bug in RenderTablePane.'),
          ErrorSpacer(),
          DiagnosticsProperty<List<double>>(
              'The computed row heights were', rowHeights),
          ErrorSpacer(),
          DiagnosticsProperty<Object>(
              'The RenderTablePane in question was created by', debugCreator,
              style: DiagnosticsTreeStyle.errorProperty),
        ]);
      }
      return true;
    }());

    return rowHeights;
  }

  List<double> _computeIntrinsicColumnWidths(
      _IntrinsicComputer computeIntrinsicCellWidth) {
    final columnWidths = List<double>.filled(columns.length, 0);
    final relativeWeights = List<double>.filled(columns.length, 0);
    final intrinsicWidthColumns = List<bool>.filled(columns.length, false);

    // First, we calculate the base widths of the columns, giving relative
    // columns their intrinsic width. Spanning cells will be ignored in this
    // pass.
    var totalRelativeWeight = 0.0;
    for (var i = 0; i < columns.length; i++) {
      final columnWidthSpec = columns[i].width;
      final columnWidth = columnWidthSpec.width;
      final isRelative = columnWidthSpec.isRelative;
      final isIntrinsic = intrinsicWidthColumns[i] = columnWidth < 0;

      if (isRelative) {
        relativeWeights[i] = columnWidth;
        totalRelativeWeight += columnWidth;
      }

      if (isIntrinsic || isRelative) {
        columnWidths[i] =
            _computeIntrinsicColumnWidth(i, computeIntrinsicCellWidth);
      } else {
        columnWidths[i] = columnWidth;
      }
    }

    // Next, we account for spanning cells, which have been ignored thus
    // far. If any spanned cell is intrinsic-width (including relative width
    // columns), then we ensure that the sum of the widths of the spanned
    // cells is enough to satisfy the intrinsic width of the spanning content
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final n = row.length;
      for (var j = 0; j < n && j < columns.length; j++) {
        final child = row[j];

        if (child is! _RenderEmptyTableCell) {
          final childParentData = child.parentData as TableCellParentData;
          final columnSpan = childParentData.columnSpan;

          if (columnSpan > 1) {
            // We might need to adjust column widths to accommodate this
            // spanning cell. First, we find out if any of the spanned cells
            // are intrinsic width or relative width and how much space we've
            // allocated thus far for those cells.
            var spannedIntrinsicWidthCellCount = 0;
            var spannedRelativeWeight = 0.0;
            var spannedWidth = 0.0;
            for (var k = 0; k < columnSpan && j + k < columns.length; k++) {
              spannedRelativeWeight += relativeWeights[j + k];
              spannedWidth += columnWidths[j + k];
              if (intrinsicWidthColumns[j + k]) {
                spannedIntrinsicWidthCellCount++;
              }
            }

            if (spannedRelativeWeight > 0 ||
                spannedIntrinsicWidthCellCount > 0) {
              bool isRelativeOrIntrinsic(TablePaneRowHeight spec) =>
                  spec.isRelative || spec.height.isNegative;

              final heightSpec = row.height;
              double heightConstraint;
              if (isRelativeOrIntrinsic(heightSpec)) {
                heightConstraint = double.infinity;
              } else {
                final rowSpan = childParentData.rowSpan;
                final spannedRowHeights = rows
                    .map<TablePaneRowHeight>(
                        (_RenderTableRow row) => row.height)
                    .skip(i)
                    .take(rowSpan);
                if (spannedRowHeights.any(isRelativeOrIntrinsic)) {
                  heightConstraint = double.infinity;
                } else {
                  heightConstraint = spannedRowHeights
                      .map<double>((TablePaneRowHeight spec) => spec.height)
                      .fold<double>(0, _sum);
                  heightConstraint +=
                      math.max(spannedRowHeights.length - 1, 0) *
                          verticalSpacing;
                }
              }
              final childIntrinsicWidth =
                  computeIntrinsicCellWidth(child, heightConstraint);

              if (childIntrinsicWidth > spannedWidth) {
                // The child's intrinsic width is larger than the width we've
                // allocated thus far, so an adjustment is necessary.
                final adjustment = childIntrinsicWidth - spannedWidth;

                if (spannedRelativeWeight > 0) {
                  // We'll distribute the adjustment across the spanned
                  // relative columns and adjust other relative column widths
                  // to keep all relative column widths reconciled.
                  final unitAdjustment = adjustment / spannedRelativeWeight;
                  for (var k = 0;
                      k < columnSpan && j + k < columns.length;
                      k++) {
                    final relativeWeight = relativeWeights[j + k];
                    if (relativeWeight > 0) {
                      final columnAdjustment = unitAdjustment * relativeWeight;
                      columnWidths[j + k] += columnAdjustment;
                    }
                  }
                } else {
                  // We'll distribute the adjustment evenly among the
                  // intrinsic-width columns.
                  for (var k = 0;
                      k < columnSpan && j + k < columns.length;
                      k++) {
                    if (intrinsicWidthColumns[j + k]) {
                      final columnAdjustment =
                          adjustment / spannedIntrinsicWidthCellCount;
                      columnWidths[j + k] += columnAdjustment;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // Finally, we adjust the widths of the relative columns upwards where
    // necessary to reconcile their widths relative to one another while
    // ensuring that they still get at least their intrinsic width
    if (totalRelativeWeight > 0) {
      // Calculate total relative width after the required upward adjustments
      var totalRelativeWidth = 0.0;
      for (var i = 0; i < columns.length; i++) {
        final relativeWeight = relativeWeights[i];
        if (relativeWeight > 0) {
          final columnWidth = columnWidths[i];
          final weightPercentage = relativeWeight / totalRelativeWeight;
          totalRelativeWidth =
              math.max(totalRelativeWidth, columnWidth / weightPercentage);
        }
      }

      // Perform the upward adjustments using the total relative width
      for (var i = 0; i < columns.length; i++) {
        final relativeWeight = relativeWeights[i];
        if (relativeWeight > 0) {
          final weightPercentage = relativeWeight / totalRelativeWeight;
          columnWidths[i] = weightPercentage * totalRelativeWidth;
        }
      }
    }

    return columnWidths;
  }

  List<double> _computeActualColumnWidths(_LinearConstraints widthConstraints) {
    final totalRelativeWeight = columns
        .map<TablePaneColumnWidth>((TablePaneColumn column) => column.width)
        .whereType<RelativeTablePaneColumnWidth>()
        .map<double>(
            (RelativeTablePaneColumnWidth widthSpec) => widthSpec.width)
        .fold<double>(0, _sum);

    final columnWidths =
        _computeIntrinsicColumnWidths(_computeIntrinsicChildWidth);
    var totalWidth = _computeWidth(columnWidths);

    void growRelativeColumnsToMeetMinimumTotalWidth(double minimumWidth) {
      final remainingWidth = minimumWidth - totalWidth;
      assert(remainingWidth >= 0);
      for (var j = 0; j < columns.length; j++) {
        final columnWidthSpec = columns[j].width;
        if (columnWidthSpec.isRelative) {
          final relativeWeight = columnWidthSpec.width;
          final weightPercentage = relativeWeight / totalRelativeWeight;
          assert(weightPercentage > 0 && weightPercentage <= 1);
          final addWidth = remainingWidth * weightPercentage;
          columnWidths[j] += addWidth;
          totalWidth += addWidth;
        }
      }
    }

    if (widthConstraints.isSatisfiedBy(totalWidth)) {
      if (horizontalRelativeSize == MainAxisSize.max &&
          widthConstraints.isBounded &&
          totalRelativeWeight > 0) {
        // Grow the relative-width columns to fill the max width constraint.
        growRelativeColumnsToMeetMinimumTotalWidth(widthConstraints.max);
      }
    } else if (widthConstraints < totalWidth) {
      if (totalRelativeWeight > 0) {
        // Shrink the relative-width columns to meet the max width constraints.
        final overflowWidth = totalWidth - widthConstraints.max;
        assert(overflowWidth >= 0);
        bool? excessiveOverflow;
        for (var j = 0; j < columns.length; j++) {
          final columnWidthSpec = columns[j].width;
          if (columnWidthSpec.isRelative) {
            final relativeWeight = columnWidthSpec.width;
            final weightPercentage = relativeWeight / totalRelativeWeight;
            assert(weightPercentage > 0 && weightPercentage <= 1);
            var subtractWidth = overflowWidth * weightPercentage;
            final localOverflow = subtractWidth > columnWidths[j];
            assert(excessiveOverflow == null ||
                excessiveOverflow == localOverflow);
            excessiveOverflow = (excessiveOverflow ?? false) || localOverflow;
            if (excessiveOverflow) {
              subtractWidth = columnWidths[j];
            }
            columnWidths[j] -= subtractWidth;
            totalWidth -= subtractWidth;
          }
        }
        //assert(excessiveOverflow == (widthConstraints < totalWidth));
        if (excessiveOverflow!) {
          // TODO: handle overflow
        }
      } else {
        // TODO: handle overflow
      }
    } else if (widthConstraints > totalWidth) {
      if (totalRelativeWeight > 0) {
        // Grow the relative-width columns to meet the min width constraints.
        growRelativeColumnsToMeetMinimumTotalWidth(widthConstraints.min);
      }
    }

    assert(() {
      if (columnWidths.any((double value) => value.isNegative)) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('RenderTablePane computed a negative-width column.'),
          ErrorDescription('This indicates a bug in RenderTablePane.'),
          ErrorSpacer(),
          DiagnosticsProperty<List<double>>(
              'The computed column widths were', columnWidths),
          ErrorSpacer(),
          DiagnosticsProperty<Object>(
              'The RenderTablePane in question was created by', debugCreator,
              style: DiagnosticsTreeStyle.errorProperty),
        ]);
      }
      return true;
    }());

    return columnWidths;
  }

  double _computeHeight(List<double> rowHeights) =>
      rowHeights.fold<double>(0, _sum) +
      math.max(rows.length - 1, 0) * verticalSpacing;

  double _computeIntrinsicHeight(
          double width, _IntrinsicComputer computeIntrinsicCellHeight) =>
      _computeHeight(
          _computeIntrinsicRowHeights(width, computeIntrinsicCellHeight));

  double _computeIntrinsicChildHeight(RenderBox child, double width) {
    switch (verticalIntrinsicSize) {
      case MainAxisSize.min:
        return child.getMinIntrinsicHeight(width);
      case MainAxisSize.max:
        return child.getMaxIntrinsicHeight(width);
    }
  }

  double _computeMinIntrinsicChildHeight(RenderBox child, double width) =>
      child.getMinIntrinsicHeight(width);

  double _computeMaxIntrinsicChildHeight(RenderBox child, double width) =>
      child.getMaxIntrinsicHeight(width);

  double _computeWidth(List<double> columnWidths) =>
      columnWidths.fold<double>(0, _sum) +
      math.max(columns.length - 1, 0) * horizontalSpacing;

  double _computeIntrinsicWidth(
          double height, _IntrinsicComputer computeIntrinsicCellWidth) =>
      _computeWidth(_computeIntrinsicColumnWidths(computeIntrinsicCellWidth));

  double _computeIntrinsicChildWidth(RenderBox child, double height) {
    switch (horizontalIntrinsicSize) {
      case MainAxisSize.min:
        return child.getMinIntrinsicWidth(height);
      case MainAxisSize.max:
        return child.getMaxIntrinsicWidth(height);
    }
  }

  double _computeMinIntrinsicChildWidth(RenderBox child, double height) =>
      child.getMinIntrinsicWidth(height);

  double _computeMaxIntrinsicChildWidth(RenderBox child, double height) =>
      child.getMaxIntrinsicWidth(height);

  @protected
  List<_RenderTableRow> get rows => children.cast<_RenderTableRow>();

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! TableRowParentData) {
      child.parentData = TableRowParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (metricsController != null) {
      metricsController!._attach(this);
    }
  }

  @override
  void detach() {
    super.detach();
    if (metricsController != null) {
      metricsController!._detach();
    }
  }

  @override
  @protected
  void markNeedsChildren() {
    super.markNeedsChildren();
    markNeedsMetrics();
  }

  @override
  @protected
  double computeMinIntrinsicHeight(double width) =>
      _computeIntrinsicHeight(width, _computeMinIntrinsicChildHeight);

  @override
  @protected
  double computeMaxIntrinsicHeight(double width) =>
      _computeIntrinsicHeight(width, _computeMaxIntrinsicChildHeight);

  @override
  @protected
  double computeMinIntrinsicWidth(double height) =>
      _computeIntrinsicWidth(height, _computeMinIntrinsicChildWidth);

  @override
  @protected
  double computeMaxIntrinsicWidth(double height) =>
      _computeIntrinsicWidth(height, _computeMaxIntrinsicChildWidth);

  @override
  @protected
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToFirstActualBaseline(baseline);

  @override
  @protected
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  bool _needsMetrics = true;
  _TablePaneMetrics? _metrics;

  @protected
  @visibleForTesting
  _TablePaneMetrics get metrics => _metrics!;

  @protected
  void markNeedsMetrics() {
    _needsMetrics = true;
    markNeedsLayout();
  }

  @protected
  void calculateMetricsIfNecessary() {
    assert(debugDoingThisLayout);
    if (_needsMetrics || metrics.constraints != constraints) {
      _metrics = _TablePaneMetrics(this);
      _needsMetrics = false;
      if (metricsController != null) {
        metricsController!._notify();
      }
    }
  }

  @override
  void performLayout() {
    calculateMetricsIfNecessary();
    size = constraints.constrainDimensions(
      _computeWidth(metrics.columnWidths),
      _computeHeight(metrics.rowHeights),
    );

    assert(() {
      if (rows.isNotEmpty) {
        final cellsPerRow = rows.first.children.length;
        if (rows
            .any((_RenderTableRow row) => row.children.length != cellsPerRow)) {
          final rowLengths = rows.map<int>((_RenderTableRow row) => row.length);
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('RenderTablePane contains irregular row lengths.'),
            ErrorDescription(
              'Every TableRow in a TablePane must have the same number of '
              'children, so that every table cell is filled. Otherwise, the '
              'table will contain holes.',
            ),
            ErrorDescription(
              'The counts of cells per row in this TablePane were: $rowLengths',
            ),
            ErrorSpacer(),
            DiagnosticsProperty<Object>(
                'The RenderTablePane in question was created by', debugCreator,
                style: DiagnosticsTreeStyle.errorProperty),
          ]);
        }
        if (cellsPerRow != columns.length) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('RenderTablePane cells do not match columns.'),
            ErrorDescription(
                'The number of children inside every TableRow must match the '
                'number of columns specified for the TablePane.'),
            ErrorSpacer(),
            IntProperty('The number of cells in each row was', cellsPerRow,
                style: DiagnosticsTreeStyle.errorProperty),
            IntProperty('The number of columns was', columns.length,
                style: DiagnosticsTreeStyle.errorProperty),
            ErrorSpacer(),
            DiagnosticsProperty<Object>(
                'The RenderTablePane in question was created by', debugCreator,
                style: DiagnosticsTreeStyle.errorProperty),
          ]);
        }
      }
      return true;
    }());

    var childY = 0.0;
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];

      final cellConstraints = <BoxConstraints>[];
      final cellPositions = <Offset>[];
      var childX = 0.0;
      var expandedRowWidth = 0.0;
      var expandedRowHeight = 0.0;
      for (var j = 0; j < row.length && j < columns.length; j++) {
        final child = row[j];

        if (child is _RenderEmptyTableCell) {
          cellConstraints.add(BoxConstraints.tight(Size.zero));
          cellPositions.add(Offset(childX, 0));
        } else {
          final childParentData = child.parentData as TableCellParentData;

          final columnSpan =
              math.min(childParentData.columnSpan, columns.length - j);
          var childWidth = metrics.columnWidths
              .skip(j)
              .take(columnSpan)
              .fold<double>(0, _sum);
          childWidth += (columnSpan - 1) * horizontalSpacing;

          final rowSpan = math.min(childParentData.rowSpan, rows.length - i);
          var childHeight =
              metrics.rowHeights.skip(i).take(rowSpan).fold<double>(0, _sum);
          childHeight += (rowSpan - 1) * verticalSpacing;

          // Set the child's size
          childWidth = math.max(childWidth, 0);
          childHeight = math.max(childHeight, 0);
          cellConstraints.add(
              BoxConstraints.tightFor(width: childWidth, height: childHeight));
          cellPositions.add(Offset(childX, 0));

          expandedRowWidth = math.max(expandedRowWidth, childX + childWidth);
          expandedRowHeight = math.max(expandedRowHeight, childHeight);
        }

        childX += metrics.columnWidths[j] + horizontalSpacing;
      }

      row.layout(TableRowConstraints.tightFor(
        width: expandedRowWidth,
        height: expandedRowHeight,
        cellConstraints: cellConstraints,
        cellPositions: cellPositions,
      ));

      (row.parentData as TableRowParentData).offset = Offset(0, childY);
      childY += metrics.rowHeights[i] + verticalSpacing;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  @protected
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('horizontalSpacing', horizontalSpacing))
      ..add(DoubleProperty('verticalSpacing', verticalSpacing))
      ..add(EnumProperty<MainAxisSize>(
          'horizontalIntrinsicSize', horizontalIntrinsicSize))
      ..add(EnumProperty<MainAxisSize>(
          'horizontalRelativeSize', horizontalRelativeSize))
      ..add(EnumProperty<MainAxisSize>(
          'verticalIntrinsicSize', verticalIntrinsicSize))
      ..add(EnumProperty<MainAxisSize>(
          'verticalRelativeSize', verticalRelativeSize))
      ..add(DiagnosticsProperty<_TablePaneMetrics?>('metrics', _metrics));
  }
}

class TablePaneMetricsController extends ChangeNotifier {
  _RenderTablePane? _renderObject;
  void _attach(_RenderTablePane renderObject) {
    assert(_renderObject == null);
    assert(renderObject.attached);
    _renderObject = renderObject;
    notifyListeners();
  }

  void _detach() {
    assert(_renderObject != null);
    _renderObject = null;
    notifyListeners();
  }

  void _notify() {
    assert(hasMetrics);
    notifyListeners();
  }

  bool get hasMetrics =>
      _renderObject != null && _renderObject!._metrics != null;

  Rect? getRowBounds(int row) {
    assert(hasMetrics);
    final verticalSpacing = _renderObject!.verticalSpacing;
    final rowHeights = _renderObject!._metrics!.rowHeights;
    if (row < 0 || row >= rowHeights.length) {
      return null;
    }
    final top =
        rowHeights.take(row).fold<double>(0, _sum) + row * verticalSpacing;
    return Rect.fromLTWH(0, top, _renderObject!.size.width, rowHeights[row]);
  }

  Rect? getColumnBounds(int column) {
    assert(hasMetrics);
    final horizontalSpacing = _renderObject!.horizontalSpacing;
    final columnWidths = _renderObject!._metrics!.columnWidths;
    if (column < 0 || column >= columnWidths.length) {
      return null;
    }
    final left = columnWidths.take(column).fold<double>(0, _sum) +
        column * horizontalSpacing;
    return Rect.fromLTWH(
        left, 0, columnWidths[column], _renderObject!.size.height);
  }
}

class _TablePaneMetrics with Diagnosticable {
  const _TablePaneMetrics._(
      this.constraints, this.columnWidths, this.rowHeights);

  factory _TablePaneMetrics(_RenderTablePane tablePane) {
    final constraints = tablePane.constraints;
    final widthConstraints = _LinearConstraints.width(constraints);
    final heightConstraints = _LinearConstraints.height(constraints);
    final columnWidths = tablePane._computeActualColumnWidths(widthConstraints);
    final rowHeights =
        tablePane._computeActualRowHeights(heightConstraints, columnWidths);
    return _TablePaneMetrics._(constraints, columnWidths, rowHeights);
  }

  final BoxConstraints constraints;
  final List<double> columnWidths;
  final List<double> rowHeights;

  @override
  @protected
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<BoxConstraints>('constraints', constraints))
      ..add(DiagnosticsProperty<List<double>>('columnWidths', columnWidths))
      ..add(DiagnosticsProperty<List<double>>('rowHeights', rowHeights));
  }
}

class _LinearConstraints extends Constraints {
  const _LinearConstraints.tight(double value)
      : min = value,
        max = value;

  _LinearConstraints.width(BoxConstraints constraints)
      : min = constraints.minWidth,
        max = constraints.maxWidth;

  _LinearConstraints.height(BoxConstraints constraints)
      : min = constraints.minHeight,
        max = constraints.maxHeight;

  final double min;
  final double max;

  double constrainMainAxisSize(MainAxisSize mainAxisSize) {
    switch (mainAxisSize) {
      case MainAxisSize.min:
        return min;
      case MainAxisSize.max:
        return max;
    }
  }

  bool isSatisfiedBy(double value) => (min <= value) && (value <= max);

  bool get isBounded => max < double.infinity;

  @override
  bool get isNormalized => min >= 0 && min <= max;

  @override
  bool get isTight => min >= max;

  bool operator <(double value) => min < value && max < value;

  bool operator <=(double value) => min <= value && max <= value;

  bool operator >(double value) => min > value && max > value;

  bool operator >=(double value) => min >= value && max >= value;

  @override
  String toString() => '_LinearConstraints($min <= x <= $max)';
}
