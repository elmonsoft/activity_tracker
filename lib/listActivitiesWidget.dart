import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'modell.dart';
import 'addActivityWidget.dart';
import 'changeThemeWidget.dart';
import 'listActivitiesSetupWidget.dart';
import 'filterActivitiesWidget.dart';

class ListActivities extends StatefulWidget {
  @override
  _ListActivitiesState createState() => _ListActivitiesState();
}

class _ListActivitiesState extends State<ListActivities> {
  List<Activity> listActivities = [];
  Set<String> _activityNames = Set<String>();
  Set<String> _filterNames = Set<String>();
  Box<ActivitySetup> setupBox;

  void updateFilterActivities() {
    setupBox = Hive.box<ActivitySetup>(activitySetupBox);
    _activityNames = Set<String>();
    _filterNames = Set<String>();
    for (int i = 0; i < setupBox.length; i++) {
      ActivitySetup setup = setupBox.getAt(i);
      _activityNames.add(setup.name);
      if (setup.filter == true) _filterNames.add(setup.name);
    }
  }

  void updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 15);
    final brightness = Theme.of(context).brightness;
    // Activity names for DropDownList
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity List'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_alt_rounded),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          FiterActivitiesWidget(onFilter: () => updateState())),
                );
                //setState(() {});
              }),
          IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangeThemeWidget()),
                );
              }),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ListActivitiesSetup()),
                );
              }),
        ],
      ),
      body: ValueListenableBuilder(
        //valueListenable: Hive.box<Activity>(activityBox).listenable(),
        valueListenable: Hive.box<Activity>(activityBox).listenable(),
        builder: (context, Box<Activity> box, _) {
          if (box.values.isEmpty) {
            print("No activities");
            return Center(
              child: Text("No activities"),
            );
          }
          updateFilterActivities();
          if (_filterNames.length > 0) {
            listActivities = box.values
                .where((element) => _filterNames.contains(element.name))
                .toList();
          } else {
            listActivities = box.values.toList();
          }
          if (listActivities.length > 0) listActivities.sort();
          return ListView.builder(
            itemCount: listActivities.length,
            itemBuilder: (context, index) {
              Activity a = listActivities[index]; //box.getAt(index);
              //print('List activity -> $a');
              Color color = Colors.blue;
              if (a.icolor != null) color = Color(a.icolor);
              final Icon icon = Icon(
                IconData(a.micon['codePoint'],
                    fontFamily: a.micon['fontFamily']),
                color: color,
                size: 40,
              );
              return InkWell(
                onLongPress: () {
                  print('longPress: $index -> ${a.toString()}');
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    child: AlertDialog(
                      content: Text(
                        "Do you want to delete ${a.name}?",
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("No"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await box.deleteAt(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: ListTile(
                  leading: icon,
                  title: Text(a.name, style: TextStyle(fontSize: 25)),
                  subtitle: Text(a.sdiff),

                  trailing: _filterNames.length > 0 ? IconButton(icon: Icon(Icons.filter_alt)) : IconButton(
                      icon: Icon(Icons.delete),
                      //color: brightness.toString()=='Brightness.dark'?Colors.white70:Colors.black87,
                      onPressed: () => a.delete()),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddActivityWidget()),
              );
            },
          );
        },
      ),
    );
  }
}
