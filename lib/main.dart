import 'package:activity_tracker/listActivitiesWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:theme_manager/change_theme_widget.dart';
import 'package:theme_manager/theme_manager.dart';
import 'dart:convert';
import 'modell.dart';
import 'listActivitiesWidget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(ActivitySetupAdapter());
  await Hive.openBox<User>(usersBox);
  getFavoriteUser();
  await Hive.openBox<Activity>(activityBox);
  await Hive.openBox<ActivitySetup>(activitySetupBox);
  runApp(MyApp());
}

void getFavoriteUser(){
  Box<User> userBox = Hive.box<User>(usersBox);
  //for (var user in userBox.values) user.delete();
  List<User> favoriteList = userBox.values.toList().where((u) => u.favorite==true).toList();
  if(favoriteList.length>0) {
    favoriteUser = favoriteList.first;
    String favoriteUserName = favoriteUser.name=='default'?'':favoriteUser.name;
    activityBox = favoriteUser.activityBox;
    activitySetupBox = favoriteUser.activitySetupBox;
    return;
  }
  // default User, if no favorite exists
  List<User> defaultList = userBox.values.toList().where((u) => u.name=='default').toList();
  if(defaultList.length>0){
    defaultList.first.favorite = true;
  }
  else {
    // create default user
    String map = '{"iconName": "portrait", "codePoint": 59716, "fontFamily": "MaterialIcons"}';
    userBox.add(User(
        name: 'default',
        micon: json.decode('{"iconName": "portrait", "codePoint": 59716, "fontFamily": "MaterialIcons"}'),
        icolor: 4278238420,
        activityBox: defaultActivityBox,
        activitySetupBox: defaultActivitySetupBox,
        favorite: true
    ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      /// WidgetsBinding.instance.window.platformBrightness is used because a
      /// Material BuildContext will not be available outside of the Material app
      defaultBrightnessPreference: BrightnessPreference.system,
      data: (Brightness brightness) => ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
        brightness: brightness,
      ),
      loadBrightnessOnStart: true,
      themedWidgetBuilder: (BuildContext context, ThemeData theme) {
        return MaterialApp(
          title: 'Actitity Tracker',
          theme: theme,
          home: FutureBuilder(
            future: Future.wait([
              Hive.openBox<Activity>(activityBox),
              //Hive.openBox<Activity>(activityBox),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.error != null) {
                  print(snapshot.error);
                  return Scaffold(
                    body: Center(
                      child: Text('Something went wrong :/'),
                    ),
                  );
                } else {
                  return ListActivities();
                }
              } else {
                return Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Loading...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
