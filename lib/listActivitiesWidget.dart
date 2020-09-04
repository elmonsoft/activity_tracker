import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'modell.dart';
import 'addActivityWidget.dart';
import 'changeThemeWidget.dart';
import 'listActivitiesSetupWidget.dart';

class ListActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 15);
    final brightness = Theme.of(context).brightness;

    return Scaffold(
        appBar: AppBar(
          title: Text('Activity List'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: () {}),
            IconButton(icon: Icon(Icons.brightness_6), onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ChangeThemeWidget()),
              );
            }),
            IconButton(icon: Icon(Icons.settings), onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ListActivitiesSetup()),
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
            List<Activity> listActivities = box.values.toList();
            listActivities.sort();
            return ListView.builder(
              itemCount: listActivities.length,
              itemBuilder: (context, index) {
                Activity a =  listActivities[index]; //box.getAt(index);
                //print('List activity -> $a');
                Color color = Colors.blue;
                if (a.icolor != null) color = Color(a.icolor) ;
                Icon icon = Icon(IconData(a.micon['codePoint'], fontFamily: a.micon['fontFamily'])
                  , color: color, size: 40,);
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
                    trailing: IconButton(icon: Icon(Icons.delete),
                        //color: brightness.toString()=='Brightness.dark'?Colors.white70:Colors.black87,
                        //onPressed: () => box.deleteAt(index)),
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
