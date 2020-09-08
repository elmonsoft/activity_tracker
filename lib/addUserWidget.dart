import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:icon_picker/icon_picker.dart';
import 'modell.dart';
import 'dart:convert';

class AddUserWidget extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  @override
  _AddUserWidgetState createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  Box<User> userBox;
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
  TextEditingController _controllerUser;
  List<String> _userNames = [];
  String _ussername;

  void onFormSubmit() {
    if (widget.formKey.currentState.validate()) {
      Box<User> userBox = Hive.box<User>(usersBox);
      final micon = json.decode(_valueToValidate);
      //
      String userName = name??'default';
      // add User
      userBox.add(User(
          name: name ?? 'activity-name',
          micon: micon,
          icolor: _mainColor.value,
          activityBox: '${userName}_$defaultActivityBox',
          activitySetupBox: '${userName}_$defaultActivitySetupBox',
      ));

      Navigator.of(context).pop();
    }
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
    _controller = TextEditingController(text: 'portrait');
    // Activity names for DropDownList
    userBox = Hive.box<User>(usersBox);
    _userNames = userBox.values.toList().map((e) => e.name).toList();
    _userNames.sort();
    print(_userNames);

    // init User-name TextField
    _controllerUser = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Form(
          key: widget.formKey,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              const SizedBox(height: 5),
              Row(children: <Widget>[
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    //autofocus: true,
                    //initialValue: '',
                    controller: _controllerUser,
                    autocorrect: false,
                    autovalidate: false,
                    style: TextStyle(fontSize: 25),
                    decoration: InputDecoration(
                      labelText: 'User',
                      hintText: '',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'empty User';
                      }
                      if(_userNames.contains(value)) return 'User exists!';
                      return null;
                    },
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
                          //_controllerUser.text = name;
                        } catch (e) {
                          print('onChaged TF: ${e.toString()}');
                        }
                      });
                    },
                  ),
                ),
              ]),
              _buildDivider(),
              Row(
                children: [
                  Flexible(
                    flex: 2,
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
                  Flexible(
                    flex: 1,
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
              const SizedBox(height: 50),
              Center(
                child: Row(
                  children: [
                    FlatButton(
                      child: Text('Cancel', style: TextStyle(fontSize: 20.0)),
                      color: Colors.red,
                      onPressed: Navigator.of(context).pop,
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                    child: FlatButton(
                      child: Text('Submit', style: TextStyle(fontSize: 20.0)),
                      color: Colors.green,
                      onPressed: onFormSubmit,
                    ),
                    ),
                  ],
                ),
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
