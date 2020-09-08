import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'modell.dart';
//import 'addActivityWidget.dart';
import 'changeThemeWidget.dart';

class ListActivitiesSetup extends StatelessWidget {

void setFavorite(ActivitySetup currentActivitySetup){
  Box<ActivitySetup> setup = Hive.box<ActivitySetup>(activitySetupBox);
  setup.values.forEach((element) {
    element.favorite = false;
    element.save();
  });
  currentActivitySetup.favorite = true;
  currentActivitySetup.save();
}

  @override
  Widget build(BuildContext context) {
    Widget _buildDivider() => const SizedBox(height: 15);
    final brightness = Theme.of(context).brightness;
    Box<User> userBox = Hive.box<User>(usersBox);
    List<User> favoriteList = userBox.values.toList().where((u) => u.favorite==true).toList();
    if(favoriteList.length>0) {
      User favoriteUser = favoriteList.first;
      activityBox = favoriteUser.activityBox;
      activitySetupBox = favoriteUser.activitySetupBox;
    }
    // Activ

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Setup List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ActivitySetup>(activitySetupBox).listenable(),
        builder: (context, Box<ActivitySetup> activitiesSetupBox, _) {
          if (activitiesSetupBox.values.isEmpty) {
            print("No activities");
            return Center(
              child: Text("No activities"),
            );
          }
          List<ActivitySetup> activitiesSetupList = activitiesSetupBox.values.toList();
          activitiesSetupList.sort();
          return ListView.builder(
            itemCount: activitiesSetupList.length, //box.length,
            itemBuilder: (context, index) {
              ActivitySetup a = activitiesSetupList[index]; //box.getAt(index);
              Color color = Colors.blue;
              if (a.icolor != null) color = Color(a.icolor) ;
              final Icon icon = Icon(IconData(a.micon['codePoint'], fontFamily: a.micon['fontFamily'])
                , color: color, size: 40,);
              return InkWell(
                onLongPress: () {
                  print('longPress: $index -> ${a.toString()}');
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    child: AlertDialog(
                      content: Text(
                        "Do you want to make ${a.name} to favorite ?",
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
                            setFavorite(a);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: ListTile(
                  leading: icon,
                  title: Text(a.name, style: TextStyle(fontSize: 25)),
                  trailing: IconButton(icon: Icon(Icons.delete),
                      color: a.favorite??false ? Colors.blueAccent : brightness.toString()=='Brightness.dark'?Colors.white70:Colors.black87,
                      //color: brightness.toString()=='Brightness.dark'?Colors.white70:Colors.black87,
                      onPressed: () => a.delete()),
                ),
              );
            },
          );
        },
      ),
      /*
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              /*
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddActivityWidget()),
              );

               */
            },
          );
        },
      ),
       */
    );
  }
}
