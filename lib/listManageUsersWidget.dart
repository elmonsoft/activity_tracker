import 'package:activity_tracker/addUserWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'modell.dart';
//import 'addActivityWidget.dart';
import 'changeThemeWidget.dart';

class ManageUsersWidget extends StatelessWidget {
  void setFavorite(User currentUser) {
    Box<User> userBox = Hive.box<User>(usersBox);
    userBox.values.forEach((element) {
      element.favorite = false;
      element.save();
    });
    currentUser.favorite = true;
    currentUser.save();
  }

  void _showDialog({User currentUser, BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: AlertDialog(
        content: Text(
          "After changing favorite User to ${currentUser.name}, activity_tracker needs to be restarted!",
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
              setFavorite(currentUser);
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 15);
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage User'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<User>(usersBox).listenable(),
        builder: (context, Box<User> userBox, _) {
          if (userBox.values.isEmpty) {
            print("No User");
            return Center(
              child: Text("No User"),
            );
          }
          List<User> userList = userBox.values.toList();
          userList.sort();
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              User a = userList[index];
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
                        "Do you want to remove ${a.name} from List of User ?",
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
                child: ListTile(
                  leading: icon,
                  title: Text(a.name, style: TextStyle(fontSize: 25)),
                  trailing: IconButton(
                      icon: a.favorite ?? false
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      color: a.favorite ?? false
                          ? Colors.blueAccent
                          : brightness.toString() == 'Brightness.dark'
                              ? Colors.white70
                              : Colors.black87,
                      //color: brightness.toString()=='Brightness.dark'?Colors.white70:Colors.black87,
                      onPressed: () =>
                          _showDialog(currentUser: a, context: context)),
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
                MaterialPageRoute(builder: (context) => AddUserWidget()),
              );
            },
          );
        },
      ),
    );
  }
}
