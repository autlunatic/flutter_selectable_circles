library selectable_circle_list;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:selectable_circle/selectable_circle.dart';
import 'package:selectable_circle_list/selectable_circle_item.dart';

import 'package:after_layout/after_layout.dart';

export 'package:selectable_circle_list/selectable_circle_item.dart';

/// Widget that displays selectable Circles in a row
///
/// It can also have two rows when the selected item has subitems
class SelectableCircleList extends StatefulWidget {
  /// creates the Widget
  SelectableCircleList(
      {@required this.children,
      this.description,
      this.subDescription,
      this.onTap,
      this.itemWidth,
      String initialValue})
      : initialValue = initialValue ?? "";

  /// a descrition that is displayed one row above the selectable items
  final Widget description;

  /// a descrition that is displayed one row above the selectable subitems
  final Widget subDescription;

  /// from these items the selectableCirles are built
  final List<SelectableCircleItem> children;

  /// when one of the circles is tapped this function is called
  final Function(String value, String subvalue) onTap;

  /// displays the List with the initial Value selected
  /// Subitemvalues are separated with |
  final String initialValue;

  /// width of a item, if null it is calculated that 4 circles fit the screen
  final double itemWidth;
  @override
  _SelectableCircleListState createState() => _SelectableCircleListState();
}

class _SelectableCircleListState extends State<SelectableCircleList>
    with AfterLayoutMixin<SelectableCircleList> {
  String _value;
  bool oneIsSelected = false;
  final _selectedKey = GlobalKey();
  final _descriptionKey = GlobalKey();
  final _subDescriptionKey = GlobalKey();

  bool madeVisible = false;

  @override
  Widget build(BuildContext context) {
    oneIsSelected = false;
    final descriptionContainer = GestureDetector(
      key: _descriptionKey,
      child: Align(alignment: Alignment.centerLeft, child: widget.description),
    );
    final subDescriptionContainer = Container(
        key: _subDescriptionKey,
        child: Align(
            alignment: Alignment.centerLeft, child: widget.subDescription));
    final selectedList =
        widget.children.where((item) => _value.startsWith("${item.value}"));
    final selected = selectedList.isNotEmpty ? selectedList.first : null;
    final needChilds = _value.isNotEmpty &&
        (selected != null) &&
        (selected.subItemList != null && selected.subItemList.isNotEmpty);
    final rowHeight = calcCircleWidth() + 16.0;
    final out = Container(
      child: Column(
        children: <Widget>[
          descriptionContainer,
          Container(
            height: rowHeight,
            child: widget.children.length < 5
                ? SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ...widget.children
                            .map(
                              _buildCircle,
                            )
                            .toList(),
                      ],
                    ),
                  )
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...widget.children
                          .map(
                            _buildCircle,
                          )
                          .toList(),
                    ],
                  ),
          ),
          if (needChilds) _buildSubitems(selected, subDescriptionContainer)
        ],
      ),
    );
    // Scrollable.ensureVisible(selected.key.currentContext);
    return out;
  }

  SelectableCircleList _buildSubitems(
      SelectableCircleItem selected, Widget subDescriptionContainer) {
    var initialValue = "";
    if (widget.initialValue.isNotEmpty) {
      final index = widget.initialValue.indexOf("|");
      if (index > 0 && widget.initialValue.length > index + 1) {
        initialValue = widget.initialValue.substring(index + 1);
      }
    }
    return SelectableCircleList(
      children: selected.subItemList
          .asMap()
          .map(
            (index, item) {
              final color = Color.lerp(
                selected.color,
                Colors.white,
                min(1.0, 0.9 * index / selected.subItemList.length),
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
      description: subDescriptionContainer,
      onTap: _onTapChild,
      initialValue: initialValue,
    );
  }

  Padding _buildCircle(SelectableCircleItem sci) {
    final isSelected = _value.startsWith(sci.value);
    final circleWidth = calcCircleWidth();
    final padding = Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: SelectableCircle(
        width: circleWidth - 10,
        color: sci.color,
        borderColor: sci.color,
        selectMode: SelectMode.check,
        isSelected: _value.startsWith(sci.value),
        key: isSelected && !oneIsSelected && !madeVisible ? _selectedKey : null,
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
    if (isSelected) {
      oneIsSelected = true;
    }
    return padding;
  }

  _onTapChild(String value, String subValue) {
    widget.onTap(_value, value);
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (oneIsSelected) {
      Scrollable.ensureVisible(_selectedKey.currentContext);
    }
    madeVisible = true;
  }

  double calcCircleWidth() {
    return widget.itemWidth ?? (MediaQuery.of(context).size.width - 20) / 4;
  }
}
