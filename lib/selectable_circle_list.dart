library selectable_circle_list;

import 'dart:async';
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
      String initialValue,
      this.canMultiselect = false,
      this.onTapMultiSelect,
      this.externalPadding = 20.00,
      bool hideSelection})
      : initialValue = initialValue ?? "",
        hideSelection = hideSelection ?? false;

  /// a descrition that is displayed one row above the selectable items
  final Widget description;

  /// a descrition that is displayed one row above the selectable subitems
  final Widget subDescription;

  /// from these items the selectableCirles are built
  final List<SelectableCircleItem> children;

  /// when one of the circles is tapped this function is called
  final Function(String value, String subvalue) onTap;

  /// when one of the circles is tapped this function is called
  final Function(List<String> values) onTapMultiSelect;

  /// displays the List with the initial Value selected
  /// Subitemvalues are separated with |
  final String initialValue;

  /// width of a item, if null it is calculated that 4 circles fit the screen
  final double itemWidth;

  /// can select more than one item, Attention! Subitems are disabled
  final bool canMultiselect;

  /// width, that is remaining on the side of the widget from the screen.
  final double externalPadding;

  /// on tap of the circle it is selected,
  /// otherwise only the tap event is called
  final bool hideSelection;
  @override
  _SelectableCircleListState createState() => _SelectableCircleListState();
}

const nothingSelected = -1;

class _SelectableCircleListState extends State<SelectableCircleList>
    with AfterLayoutMixin<SelectableCircleList> {
  final _values = <String>[];
  bool _canShowItemsInRow = false;
  int _selectedIndex = nothingSelected;
  final _selectedKey = GlobalKey();
  final _descriptionKey = GlobalKey();
  final _subDescriptionKey = GlobalKey();
  final _scrollController = ScrollController();

  bool madeVisible = false;

  @override
  Widget build(BuildContext context) {
    _selectedIndex = nothingSelected;
    final descriptionContainer = GestureDetector(
      key: _descriptionKey,
      child: Align(alignment: Alignment.centerLeft, child: widget.description),
    );
    final subDescriptionContainer = Container(
        key: _subDescriptionKey,
        child: Align(
            alignment: Alignment.centerLeft, child: widget.subDescription));
    final selectedList =
        widget.children.where((item) => _values.contains("${item.value}"));
    final selected = selectedList.isNotEmpty ? selectedList.first : null;
    final needChilds = !widget.canMultiselect &&
        _values.isNotEmpty &&
        (selected != null) &&
        (selected.subItemList != null && selected.subItemList.isNotEmpty);
    final circleWidth = calcCircleWidth();
    final rowHeight = calcCircleWidth() + 16.0;
    _canShowItemsInRow = widget.children.length * circleWidth <
        MediaQuery.of(context).size.width - widget.externalPadding;
    final out = Container(
      child: Column(
        children: <Widget>[
          descriptionContainer,
          Container(
            height: rowHeight,
            child: _canShowItemsInRow
                ? SingleChildScrollView(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ...widget.children
                            .asMap()
                            .map((index, value) =>
                                MapEntry(index, _buildCircle(index, value)))
                            .values
                            .toList(),
                      ],
                    ),
                  )
                : ListView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    children: [
                      ...widget.children
                          .asMap()
                          .map((index, value) =>
                              MapEntry(index, _buildCircle(index, value)))
                          .values
                          .toList(),
                    ],
                  ),
          ),
          if (needChilds) _buildSubitems(selected, subDescriptionContainer)
        ],
      ),
    );
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
      itemWidth: widget.itemWidth,
      externalPadding: widget.externalPadding,
    );
  }

  Widget _buildCircle(int index, SelectableCircleItem sci) {
    final isSelected = !widget.hideSelection && _values.contains(sci.value);
    final circleWidth = calcCircleWidth();
    final padding = Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: SelectableCircle(
        width: circleWidth - 10,
        color: sci.color,
        borderColor: sci.color,
        selectMode: SelectMode.check,
        isSelected: isSelected,
        key: isSelected && _selectedIndex == nothingSelected && !madeVisible
            ? _selectedKey
            : null,
        child: sci.centerWidget,
        bottomDescription: Text(sci.description),
        onTap: () {
          doOnTap(sci.value);
        },
      ),
    );
    if (isSelected && _selectedIndex == nothingSelected) {
      _selectedIndex = index;
    }
    return padding;
  }

  _onTapChild(String value, String subValue) {
    widget.onTap(_values[0], value);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue.isNotEmpty) {
      _values.addAll(widget.initialValue.split("|"));
      print(_values);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (_selectedIndex >= 0) {
      if (!_canShowItemsInRow) {
        Timer(
          Duration(milliseconds: 200),
          () {
            final scrollextent = _scrollController.position.maxScrollExtent -
                (widget.children.length - _selectedIndex - 1) *
                    calcCircleWidth();
            if (scrollextent > 0) {
              _scrollController.animateTo(scrollextent,
                  curve: Curves.easeOut, duration: Duration(milliseconds: 300));
            }
          },
        );
      }
    }
    madeVisible = true;
  }

  double calcCircleWidth() {
    return widget.itemWidth ?? (MediaQuery.of(context).size.width - 20) / 4;
  }

  void doOnTap(String value) {
    print(widget.canMultiselect);
    if (widget.canMultiselect) {
      setState(() {
        if (_values.contains(value)) {
          _values.remove(value);
        } else {
          _values.add(value);
        }
      });
      if (widget.onTapMultiSelect != null) {
        widget.onTapMultiSelect(_values);
      }
    } else {
      _values.clear();
      setState(() {
        _values.add(value);
      });
      if (widget.onTap != null) {
        widget.onTap(value, "");
      }
    }
  }
}
