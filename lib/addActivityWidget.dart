import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:icon_picker/icon_picker.dart';
import 'modell.dart';
import 'dart:convert';

class AddActivityWidget extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  @override
  _AddActivityWidgetState createState() => _AddActivityWidgetState();
}

class _AddActivityWidgetState extends State<AddActivityWidget> {
  String name;
  DateTime begin;
  DateTime last;
  var dateTimeField = ComplexDateTimeField24();
  Widget _buildDivider() => const SizedBox(height: 25);
  Color _mainColor = Colors.blue;
  Color _tempMainColor;
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  TextEditingController _controller;
  TextEditingController _controllerActivityName;
  Set<String> _activityNames = Set<String>();
  String _activityname;

  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      Box<Activity> box = Hive.box<Activity>(activityBox);
      Box<ActivitySetup> setup = Hive.box<ActivitySetup>(activitySetup);
      begin = dateTimeField.dtbegin;
      final micon = json.decode(_valueToValidate);
      //
      var filteredActivity =
          box.values.where((activity) => activity.name == name);
      List<Activity> listFilteredActivities = [];
      filteredActivity.forEach((element) {
        listFilteredActivities.add(element);
      });
      if (listFilteredActivities.isNotEmpty) {
        last = listFilteredActivities[0].begin;
      }

      // add Activity
      box.add(Activity(
          name: name ?? 'activity-name',
          begin: begin,
          last: last ?? begin,
          micon: micon,
          icolor: _mainColor.value));
      // setup: add Activity
      if (name != null && !_activityNames.contains(name)) {
        setup.add(ActivitySetup(name: name, micon: micon, icolor: _mainColor.value));
      }
      Navigator.of(context).pop();
    }
  }

  void onDBchanged() {
    // Wert aus setup uebernehmen
    Box<ActivitySetup> setupBox = Hive.box<ActivitySetup>(activitySetup);
    var setupActivity =
        setupBox.values.where((activitySetup) => activitySetup.name == name);
    ActivitySetup firstActSetup = setupActivity.first;
    _mainColor = Color(firstActSetup.icolor);
    _controller = TextEditingController(text: firstActSetup.micon['iconName']);
    setState(() {});
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                //setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Main Color picker",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: 'directions_walk');
    _controllerActivityName = TextEditingController(text: '');
    // Activity names for DropDownList
    Box<ActivitySetup> setupBox = Hive.box<ActivitySetup>(activitySetup);
    for (int i = 0; i < setupBox.length; i++) {
      ActivitySetup setup = setupBox.getAt(i);
      //print('$i -> ${setup.toString()}');
      _activityNames.add(setup.name);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerActivityName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add Activity'),
      ),
      body: SafeArea(
        child: Form(
          key: widget.formKey,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              const SizedBox(height: 10),
              Row(children: <Widget>[
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    //autofocus: true,
                    //initialValue: '',
                    controller: _controllerActivityName,
                    autocorrect: false,
                    autovalidate: false,
                    style: TextStyle(fontSize: 25),
                    decoration: InputDecoration(
                      labelText: 'Activity',
                      hintText: '',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (val) {
                      setState(() {
                        try {
                          name = val;
                        } catch (e) {
                          print('onFieldSubmitted: ${e.toString()}');
                        }
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        try {
                          name = value;
                        } catch (e) {
                          print('onChaged TF: ${e.toString()}');
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                    child: Column(children: <Widget>[
                  DropdownButton(
                    iconSize: 44,
                    value: _activityname,
                    isDense: true,
                    onChanged: (String newValue) {
                      try {
                        name = newValue;
                        _controllerActivityName.text = name;
                        onDBchanged();
                      } catch (e) {
                        print('onChaged DdB: ${e.toString()}');
                      }
                    },
                    items: _activityNames.toList().map((String value) {
                      return new DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList(),
                  ),
                ])),
              ]),
              _buildDivider(),
              dateTimeField, // ComplexDateTimeField24(now: now, last: last),
              _buildDivider(),
              Row(
                children: [
                  Expanded(
                    child: IconPicker(
                      style: TextStyle(fontSize: 18),
                      cursorColor: _mainColor,
                      controller: _controller,
                      //initialValue: _initialValue,
                      icon: Icon(
                        Icons.apps,
                        color: _mainColor,
                        size: 40,
                      ),
                      labelText: "Icon",
                      enableSearch: true,
                      onChanged: (val) => setState(() => _valueChanged = val),
                      validator: (val) {
                        setState(() => _valueToValidate = val);
                        return null;
                      },
                      onSaved: (val) => setState(() => _valueSaved = val),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: FlatButton(
                      color: _mainColor,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      onPressed: _openMainColorPicker,
                      child: Text(
                        "color",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              ),

              _buildDivider(),
              _buildDivider(),
              OutlineButton(
                child: Text("Submit", style: TextStyle(fontSize: 20.0)),
                onPressed: onFormSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComplexDateTimeField24 extends StatefulWidget {
  DateTime begin;
  DateTime last;

  DateTime get dtbegin => this.begin;

  ComplexDateTimeField24({this.begin, this.last});

  @override
  _ComplexDateTimeFieldState24 createState() => _ComplexDateTimeFieldState24();
}

class _ComplexDateTimeFieldState24 extends State<ComplexDateTimeField24> {
  final format = DateFormat("E dd.MM.yyyy HH:mm"); // "yyyy-MM-dd HH:mm"
  final initialValue = DateTime.now();
  DateTime value = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.begin = value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //Text('Activity begin'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child),
            );
            widget.begin = DateTimeField.combine(date, time);
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
        autovalidate: true,
        validator: (date) => date == null ? 'Invalid date' : null,
        initialValue: initialValue,
        onChanged: (date) => setState(() {
          value = date;
        }),
        onSaved: (date) => setState(() {
          value = date;
          widget.begin = value;
        }),
        resetIcon: Icon(Icons.delete),
        readOnly: true,
        style: TextStyle(fontSize: 20),
        //decoration: InputDecoration(helperText: 'Changed:  $value'),
        decoration: InputDecoration(
          labelText: 'Activity begin',
          hintText: '',
          border: OutlineInputBorder(),
        ),
      ),
    ]);
  }
}
