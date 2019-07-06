# selectable_circle_list

A flutter widget to display selecetable_circles in a list.
You should be able to select the circles.
You can define Subitems per item.

## How to use

    SelectableCircleList(
        children: _buildItems(),
        description: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("test"),
        ),
        subDescription: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("subtest"),
        ),
        onTap: _onTapCircle,
        initialValue: "6|subsixth",
    )

    List<SelectableCircleItem> _buildItems() {
        return <SelectableCircleItem>[
            SelectableCircleItem(
                Icon(Icons.description), "first", "first", Colors.red),
            SelectableCircleItem(
                Icon(Icons.ac_unit), "second", "second", Colors.orange),
            SelectableCircleItem(
                Icon(Icons.ac_unit), "third", "third", Colors.blue),
            SelectableCircleItem(
                Icon(Icons.ac_unit), "may the 4th", "forth", Colors.green),
            SelectableCircleItem(
                Icon(Icons.ac_unit), "fifth", "fifth", Colors.orange),
            SelectableCircleItem(
                Icon(Icons.ac_unit),
                "6",
                "6",
                Colors.green,
                subItemList: [
                SelectableCircleSubItem("subfirst", "subfirst"),
                SelectableCircleSubItem("subsecond", "subsecond"),
                SelectableCircleSubItem("subthird", "subthird"),
                SelectableCircleSubItem("subfourth", "subfourth"),
                SelectableCircleSubItem("subfifth", "subfifth"),
                SelectableCircleSubItem("subsixth", "subsixth"),
                ],
            ),
        ];
    }

#Screenshot

<img src="https://github.com/autlunatic/flutter_selectable_circles/blob/master/screenshots/sc.gif?raw=true" width="240"/>

#Contribution
Contribution is more than welcome.
