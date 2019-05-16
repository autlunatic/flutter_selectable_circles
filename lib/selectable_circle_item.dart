import 'package:flutter/material.dart';

/// Holds the information to create a SelectableCircle
class SelectableCircleItem {
  /// creates the Item
  SelectableCircleItem(
    this.centerWidget,
    this.description,
    this.value,
    this.color, {
    this.subItemList,
  }) : key = GlobalKey();

  /// this widget is displayed in the center of the circle
  final Widget centerWidget;

  /// it is used as a Text at the bottom of the circle
  final String description;

  /// the value that is set when the circ le is tapped
  final String value;

  /// color of the circle
  final Color color;

  /// key
  final GlobalKey key;

  /// if the Item has subitems, these are displayed in a second row
  /// the subitems have the same centerwidget
  /// the color of the subitems is taken from the parent and
  /// automatically lerped to white, when more items a displayed
  final SelectableCircleSubItems subItemList;
}

/// Subitems are used in the [SelectableCircleItem]
class SelectableCircleSubItems {
  /// creates the subitems
  SelectableCircleSubItems(this.description, this.items);

  /// description of the subitems
  final Widget description;

  /// List of the subitems to be displayed
  final List<SelectableCircleSubItem> items;
}

/// Information for one Subitem of a [SelectableCircleItem]
class SelectableCircleSubItem {
  /// bottom description of the circle
  final String description;

  /// Value that is set as subvalue when the wubitem is tapped
  final String value;

  /// creates the SubItem
  SelectableCircleSubItem(this.description, this.value);
}
