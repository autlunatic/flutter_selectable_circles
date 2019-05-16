library selectable_circle_list;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:selectable_circle/selectable_circle.dart';
import 'package:selectable_circle_list/selectable_circle_item.dart';

/// Widget that displays selectable Circles in a row
///
/// It can also have two rows when the selected item has subitems
class SelectableCircleList extends StatefulWidget {
  /// creates the Widget
  SelectableCircleList({
    @required this.children,
    this.description,
    this.onTap,
    this.itemWidth,
  });

  /// a descrition that is displayed one row above the selectable items
  final Widget description;

  /// from these items the selectableCirles are built
  final List<SelectableCircleItem> children;

  /// when one of the circles is tapped this function is called
  final Function(String value, String subvalue) onTap;

  /// width of a item, if null its calculated that 4 circles fit the screen
  final double itemWidth;
  @override
  _SelectableCircleListState createState() => _SelectableCircleListState();
}

class _SelectableCircleListState extends State<SelectableCircleList> {
  String _value = "first";
  @override
  Widget build(BuildContext context) {
    final selectedList =
        widget.children.where((item) => _value.startsWith("${item.value}"));
    final selected = selectedList.isNotEmpty ? selectedList.first : null;
    final needChilds = _value.isNotEmpty &&
        (selected != null) &&
        (selected.subItemList != null && selected.subItemList.items.isNotEmpty);
    final circleWidth =
        widget.itemWidth ?? (MediaQuery.of(context).size.width - 20) / 4;
    final rowHeight = circleWidth + 16.0;
    final completeHeight = rowHeight + 16.0;
    final height = needChilds ? completeHeight * 2 : completeHeight;
    final out = Container(
      height: height,
      child: Column(
        children: <Widget>[
          Align(alignment: Alignment.centerLeft, child: widget.description),
          Container(
            height: rowHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...widget.children
                    .map(
                      (sci) => _buildCircle(circleWidth, sci),
                    )
                    .toList(),
              ],
            ),
          ),
          if (needChilds) _buildSubitems(selected)
        ],
      ),
    );
    // Scrollable.ensureVisible(selected.key.currentContext);
    return out;
  }

  SelectableCircleList _buildSubitems(SelectableCircleItem selected) {
    return SelectableCircleList(
      children: selected.subItemList.items
          .asMap()
          .map(
            (index, item) {
              final color = Color.lerp(
                selected.color,
                Colors.white,
                min(1.0, 0.9 * index / selected.subItemList.items.length),
              );
              return MapEntry(
                index,
                SelectableCircleItem(
                  selected.centerWidget,
                  item.description,
                  item.value,
                  color,
                ),
              );
            },
          )
          .values
          .toList(),
      description: selected.subItemList.description,
      onTap: _onTapChild,
    );
  }

  Padding _buildCircle(double circleWidth, SelectableCircleItem sci) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: SelectableCircle(
        width: circleWidth - 10,
        color: sci.color,
        borderColor: sci.color,
        selectMode: SelectMode.check,
        isSelected: _value.startsWith(sci.value),
        child: sci.centerWidget,
        bottomDescription: Text(sci.description),
        onTap: () {
          setState(() {
            _value = "${sci.value}";
          });
          widget.onTap(sci.value, "");
        },
      ),
    );
  }

  _onTapChild(String value, String subValue) {
    widget.onTap(_value, value);
  }
}
