import 'package:activity_tracker/addUserWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'modell.dart';
import 'addUserIconWidget.dart';
import 'changeThemeWidget.dart';

class ManageUserIconsWidget extends StatelessWidget {
  /*
  void setFavorite(User currentUser) {
    Box<UserIcon> iconBox = Hive.box<UserIcon>(iconsBox);
    iconBox.values.forEach((element) {
      element.save();
    });
    currentUser.favorite = true;
    currentUser.save();
  }
   */
/*
  void _showDialog({UserIcon currentIcon, BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: AlertDialog(
        content: Text(
          "After changing favorite User to ${currentIcon.name}, activity_tracker needs to be restarted!",
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              //Navigator.of(context).pop();
              //SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
 */

  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 15);
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Icons'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<UserIcon>(iconsBox).listenable(),
        builder: (context, Box<UserIcon> iconBox, _) {
          if (iconBox.values.isEmpty) {
            print("No Icon");
            return Center(
              child: Text("No Icon"),
            );
          }
          List<UserIcon> userIconList = iconBox.values.toList();
          //userIconList.sort();
          return ListView.builder(
            itemCount: userIconList.length,
            itemBuilder: (context, index) {
              UserIcon a = userIconList[index];
              Color color = Colors.blue;
              final Icon icon = Icon(MdiIcons()[a.name], color: color, size: 40,);
              return InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    child: AlertDialog(
                      content: Text(
                        "Do you want to remove ${a.name} from List of Icons ?",
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("No"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton(
                          child: Text("Yes"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            a.delete();
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
                MaterialPageRoute(builder: (context) => AddUserIconWidget()),
              );
            },
          );
        },
      ),
    );
  }
}
