import 'package:activity_tracker/listActivitiesWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'modell.dart';

class FiterActivitiesWidget extends StatefulWidget {
  FiterActivitiesWidget({Key key, this.onFilterList}) : super(key: key);
  final Function(List<ActivitySetup> list) onFilterList;

  @override
  _FiterActivitiesWidgetState createState() => _FiterActivitiesWidgetState();
}

class _FiterActivitiesWidgetState extends State<FiterActivitiesWidget> {
  Set<String> _activityNames = Set<String>();
  List<ActivitySetup> _filterActivities = List<ActivitySetup>();

  @override
  void initState() {
    super.initState();
    ActivitySetup activitySetupTemp;
    var activitySetupList;

    Box<Activity> box = Hive.box<Activity>(activityBox);
    Box<ActivitySetup> setupActivityBox =
        Hive.box<ActivitySetup>(activitySetupBox);
    /*
    activitySetupList = setupActivityBox.values
        .where((activitySetup) => activitySetup.filter == true)
        .toList();

    for (int i = 0; i < activitySetupList.length; i++) {
      setupActivityBox.getAt(i).filter = false; // reset filter
    }

     */

    for (int i = 0; i < box.length; i++) {
      _activityNames.add(box.getAt(i).name);
    }
    for (String name in _activityNames) {
      activitySetupList = setupActivityBox.values
          .where((activitySetup) => activitySetup.name == name);
      if (activitySetupList.length > 0) {
        _filterActivities.add(activitySetupList.first);
      } else {
        // Aktivität-name nicht mehr in activitySetup, wird also neu erstellt
        activitySetupList =
            box.values.where((activity) => activity.name == name);
        activitySetupTemp = ActivitySetup(
            name: name,
            micon: activitySetupList.first.micon,
            icolor: activitySetupList.first.icolor);
        activitySetupTemp.filter = false;
        _filterActivities.add(activitySetupTemp);
      }
      if (_filterActivities.length > 0) _filterActivities.sort();
    }
    for (ActivitySetup reset_filter in _filterActivities) {
      reset_filter.filter = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Activities'),
      ),
      body: ListView.builder(
        itemCount: _filterActivities.length, //box.length,
        itemBuilder: (context, index) {
          ActivitySetup a = _filterActivities[index]; //box.getAt(index);
          final Icon icon = Icon(
            IconData(a.micon['codePoint'], fontFamily: a.micon['fontFamily']),
            color: Color(a.icolor),
            size: 40,
          );
          return ListTile(
            leading: icon,
            title: Text(a.name, style: TextStyle(fontSize: 25)),
            trailing: IconButton(
              icon: Icon(Icons.check_box),
              color: a.filter ?? false ? Colors.greenAccent : Colors.grey,
              onPressed: () {
                //a.filter = !a.filter;
                _filterActivities[index].filter =
                    !_filterActivities[index].filter;
                setState(() {});
                widget.onFilterList(
                    _filterActivities.where((e) => e.filter == true).toList());
              },
            ),
          );
        },
      ),
    );
  }
}
