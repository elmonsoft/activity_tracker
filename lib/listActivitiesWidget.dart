import 'package:activity_tracker/listManageUserIconsWidget.dart';
import 'package:activity_tracker/listManageUsersWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'modell.dart';
import 'addActivityWidget.dart';
import 'changeThemeWidget.dart';
import 'listActivitiesSetupWidget.dart';
import 'filterActivitiesWidget.dart';
import 'listManageUsersWidget.dart';

class ListActivities extends StatefulWidget {
  @override
  _ListActivitiesState createState() => _ListActivitiesState();
}

class _ListActivitiesState extends State<ListActivities> {
  Box<Activity> box;
  List<Activity> listActivities = [];
  List<ActivitySetup> _filterActivities = [];
  Set<String> _filterNames = Set<String>();
  String favoriteUserName;


  void updateFilterActivities(List<ActivitySetup> filter) {
    _filterNames = Set<String>();
    setState(() {
      _filterNames = Set<String>();
    });
    for (int i = 0; i < filter.length; i++) {
      if (filter[i].filter == true) _filterNames.add(filter[i].name);
      setState(() {
        listActivities = box.values
            .where((element) => _filterNames.contains(element.name))
            .toList();
      });
    }
  }

  void addActivity(Activity activity) async {
    DateTime begin = DateTime.now();
    DateTime last;
    //
    var filteredActivity = box.values
        .where((aactivity) => aactivity.name == activity.name)
        .toList();
    filteredActivity.sort();
    if (filteredActivity.length > 0) last = filteredActivity.first.begin;

    // add Activity
    await box.add(Activity(
        name: activity.name,
        begin: begin,
        last: last ?? begin,
        micon: activity.mapIcon,
        icolor: activity.intColor));
    // setup: add Activity
    //Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    activityBox = favoriteUser.activityBox;
    activitySetupBox = favoriteUser.activitySetupBox;
    box = Hive.box<Activity>(activityBox);
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 15);
    final brightness = Theme.of(context).brightness;
    String userName = favoriteUser.name=='default'?'':favoriteUser.name;
    var myList;
    // Activity names for DropDownList
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity List $userName'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_alt_rounded),
              onPressed: () {
                setState(() {
                  _filterNames = Set<String>();
                  listActivities = Hive.box<Activity>(activityBox).values.toList();
                });
                 Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FiterActivitiesWidget(
                            onFilterList: (filterList) {
                              updateFilterActivities(filterList);
                            })) //updateState())),
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
              icon: Icon(Icons.portrait_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ManageUsersWidget()),
                );
              }),
          IconButton(
              icon: Icon(Icons.work),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ManageUserIconsWidget()),
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
        valueListenable: Hive.box<Activity>(activityBox).listenable(),
        builder: (context, Box<Activity> box, _) {
          if (box.values.isEmpty) {
            print("No activities");
            return Center(
              child: Text("No activities"),
            );
          }
          //updateFilterActivities();
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
              Activity a = listActivities[index];
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
                child: Dismissible(
                  // Show a red background as the item is swiped away.
                  background: Container(color: Colors.redAccent),
                  key: Key(DateTime.now().microsecond.toString()),
                  onDismissed: (direction) async {
                    try {
                      await a.delete();
                    } catch (e) {
                      print('error Dismiss $a \n${e.toString()}');
                    }
                    //setState(() {});
/*
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(
                      backgroundColor: Colors.deepOrange,
                        content: Text("${a.name} dismissed")));

 */
                  },
                  child: ListTile(
                    leading: icon,
                    title: Text(a.name, style: TextStyle(fontSize: 25)),
                    subtitle: Text(a.sdiff),
                    trailing: _filterNames.length > 0
                        ? IconButton(icon: Icon(Icons.filter_alt))
                        : IconButton(
                            icon: Icon(Icons.content_copy, size: 25,),
                            //color: brightness.toString()=='Brightness.dark'?Colors.white70:Colors.black87,
                            onPressed: () async => await addActivity(a)),
                  ),
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
