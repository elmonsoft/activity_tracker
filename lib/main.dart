import 'package:activity_tracker/listActivitiesWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:theme_manager/change_theme_widget.dart';
import 'package:theme_manager/theme_manager.dart';
import 'modell.dart';
import 'listActivitiesWidget.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(ActivitySetupAdapter());
  await Hive.openBox<Activity>(activityBox);
  await Hive.openBox<ActivitySetup>(activitySetupBox);
  runApp(MyApp());
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
