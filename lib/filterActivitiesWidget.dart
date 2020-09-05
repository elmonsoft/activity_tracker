import 'package:activity_tracker/listActivitiesWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'modell.dart';

class FiterActivitiesWidget extends StatefulWidget {
  const FiterActivitiesWidget({Key key, this.onFilter}) : super(key: key);

  final VoidCallback onFilter;

  @override
  _FiterActivitiesWidgetState createState() => _FiterActivitiesWidgetState();
}

class _FiterActivitiesWidgetState extends State<FiterActivitiesWidget> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Activities'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ActivitySetup>(activitySetupBox).listenable(),
        builder: (context, Box<ActivitySetup> box, _) {
          if (box.values.isEmpty) {
            print("No activities");
            return Center(
              child: Text("No activities"),
            );
          }
          List<ActivitySetup> setupActivities = box.values.toList();
          setupActivities.sort();
          return ListView.builder(
            itemCount: setupActivities.length, //box.length,
            itemBuilder: (context, index) {
              ActivitySetup a = setupActivities[index]; //box.getAt(index);
              Color color = Colors.blue;
              if (a.icolor != null) color = Color(a.icolor);
              final Icon icon = Icon(
                IconData(a.micon['codePoint'],
                    fontFamily: a.micon['fontFamily']),
                color: color,
                size: 40,
              );
              return ListTile(
                leading: icon,
                title: Text(a.name, style: TextStyle(fontSize: 25)),
                trailing: IconButton(
                  icon: Icon(Icons.check_box),
                  color: a.filter ?? false ? Colors.greenAccent : Colors.grey,
                  onPressed: () {
                    a.filter = !a.filter;
                    setState(() {});
                    widget.onFilter();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
