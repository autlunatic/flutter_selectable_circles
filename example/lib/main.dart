import 'package:flutter/material.dart';
import 'package:selectable_circle_list/selectable_circle_item.dart';
import 'package:selectable_circle_list/selectable_circle_list.dart';

void main() => runApp(MyApp());

/// example app
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'selectable circles demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

/// home widget of the example app
class MyHomePage extends StatefulWidget {
  /// creates the widget
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('selectable circles demo'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: SelectableCircleList(
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
                initialValue: "6",
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SelectableCircleItem> _buildItems() {
    return <SelectableCircleItem>[
      SelectableCircleItem(
          Icon(Icons.description), "first", "first", Colors.red),
      SelectableCircleItem(
          Icon(Icons.ac_unit), "second", "second", Colors.orange),
      SelectableCircleItem(Icon(Icons.ac_unit), "third", "third", Colors.blue),
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

  _onTapCircle(String value, String subvalue) {
    print("tapped $value $subvalue");
  }
}
