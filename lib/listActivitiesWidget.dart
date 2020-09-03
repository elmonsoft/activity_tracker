import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'modell.dart';
import 'addActivityWidget.dart';
import 'main.dart';


class ListActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 15);
    var customList = Hive.box<Activity>(activityBox);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    //final String formatted = formatter.format(now);


    return Scaffold(
        appBar: AppBar(
          title: Text('Activity List'),
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
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                Activity a = box.getAt(index);
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
                    trailing: Icon(Icons.delete),
                  ),
                  /*
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildDivider(),
                          Text(a.name ?? ''),
                          _buildDivider(),
                          Text("begin: ${a.sbegin}"),
                          _buildDivider(),
                          Text("last: ${a.slast}"),
                          _buildDivider(),
                          Icon(IconData(a.micon['codePoint'], fontFamily: a.micon['fontFamily']), color: color, size: 30,),
                          Text("color: ${a.icolor}"),
                          Text("diff: ${a.sdiff}"),
                          _buildDivider(),
                        ],
                      ),
                    ),
                  ),

                   */
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
