import 'package:flutter/material.dart';
import 'package:selectable_circle_list/selectable_circle_item.dart';
import 'package:selectable_circle_list/selectable_circle_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final list = <SelectableCircleItem>[
      SelectableCircleItem(
        Icon(Icons.description),
        "first",
        "first",
        Colors.red,
        subItemList: SelectableCircleSubItems("Special", [
          SelectableCircleSubItem("subfirst", "subfirst"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
          SelectableCircleSubItem("subsecond", "subsecond"),
        ]),
      ),
      SelectableCircleItem(
        Icon(Icons.ac_unit),
        "second",
        "second",
        Colors.orange,
        subItemList: SelectableCircleSubItems(
          "Special",
          [
            SelectableCircleSubItem("subfirst", "subfirst"),
            SelectableCircleSubItem("subsecond", "subsecond"),
            SelectableCircleSubItem("subsecond", "subsecond"),
          ],
        ),
      ),
      SelectableCircleItem(
        Icon(Icons.ac_unit),
        "third",
        "third",
        Colors.blue,
        subItemList: SelectableCircleSubItems(
          "Special",
          [
            SelectableCircleSubItem("subfirst", "subfirst"),
            SelectableCircleSubItem("subsecond", "subsecond"),
            SelectableCircleSubItem("subsecond", "subsecond"),
            SelectableCircleSubItem("subsecond", "subsecond"),
          ],
        ),
      ),
      SelectableCircleItem(
          Icon(Icons.ac_unit), "may the 4th", "forth", Colors.green),
      SelectableCircleItem(
          Icon(Icons.ac_unit), "fifth", "fifth", Colors.orange),
      SelectableCircleItem(Icon(Icons.ac_unit), "6", "6", Colors.green),
      SelectableCircleItem(Icon(Icons.ac_unit), "7", "7", Colors.green),
      SelectableCircleItem(Icon(Icons.ac_unit), "8", "8", Colors.green),
      SelectableCircleItem(Icon(Icons.ac_unit), "9", "9", Colors.green),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            // Text("asdf"),
            // Text("eieie"),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SelectableCircleList(
                list,
                description: "test",
                // width: 90.0,
                onTap: onTapCircle,
              ),
            ),
            Text("asdf"),
          ],
        ),
      ),
    );
  }

  onTapCircle(String value, String subvalue) {
    print("tapped $value $subvalue");
  }
}
