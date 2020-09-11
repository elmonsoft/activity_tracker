import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'modell.dart';

class AddUserIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('add Icons'),
        ),
        body: IconPickerDialog());
  }
}

class IconPickerDialog extends StatefulWidget {
  final String searchHint;

  IconPickerDialog({Key key, this.searchHint}) : super(key: key);

  @override
  _IconPickerDialogState createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  Box<UserIcon> iconBox;
  TextEditingController _oCtrlSearchQuery;
  Map<String, IconData> _mIconsShow = <String, IconData>{};
  Map<String, IconData> _mIconsFind = <String, IconData>{};
  Map<String, IconData> _iconCollection = <String, IconData>{};
  int _iQtIcons = -1;
  int _iQtFindIcons = -1;

  void addUserIcon(String iconName, int codePoint, String iconFontFamily, String iconFontPackage){
    String icon_raw = '{"iconName": "$iconName", "codePoint": $codePoint, "fontFamily": "$iconFontFamily", "fontPackage": "$iconFontPackage"}';
    Map micon = json.decode(icon_raw);
    iconBox.add(UserIcon(name: iconName, codePoint: codePoint, fontFamily: iconFontFamily, micon: micon));
  }

  @override
  void initState() {
    super.initState();
    iconBox = Hive.box<UserIcon>(iconsBox);
    //_oCtrlSearchQuery.addListener(_search);
    _oCtrlSearchQuery = TextEditingController();
    iconMap.keys.forEach((key) {
      _iconCollection[key] = MdiIcons()[key];
    });
    _loadIcons();
  }

  @override
  void dispose() {
    _oCtrlSearchQuery.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height=0.0;
    if(_mIconsFind.length>0){
      _height = 10.0;
    }
    return Column(
      children: <Widget>[
        _titleDialog(),
        SizedBox(height: 10),
        Flexible(child: _content('find'),
        fit: FlexFit.loose,
        flex: 1,),
        SizedBox(height: _height),
        Text('found ${_mIconsFind.length}',style: TextStyle(fontSize: 12)),
        SizedBox(height: 20),
        Flexible(child: _content('list'),
          fit: FlexFit.tight,
        flex: 3,),
        //Text('Zeilenende'),
      ],
    );
  }

  Widget _titleDialog() {
    if (_iQtIcons == 0) {
      return Text('Select an icon');
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Form(
        key: _oFormKey,
        child: Column(
          children: <Widget>[
            //Text('Select an icon'),
            TextField(
              controller: _oCtrlSearchQuery,
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                hintText: widget.searchHint ?? 'Search icon',
                suffixIcon: Container(
                  width: 10,
                  margin: EdgeInsets.all(0),
                  child: FlatButton(
                    padding: EdgeInsets.only(top: 15),
                    child: Icon(Icons.delete),
                    onPressed: () {
                      _oCtrlSearchQuery.text = '';
                      _mIconsFind = <String, IconData>{};
                      _loadIcons();
                    },
                  ),
                ),
              ),
              onChanged: (val) => _search(),
            ),
          ],
        ),
      ),
    );
  }

  void _loadIcons() {
    setState(() {
      _mIconsShow.clear();
      _mIconsShow.addAll(_iconCollection);
      _iQtIcons = _mIconsShow.length;
    });
  }

  Widget _content(String type) {

    if (_iQtIcons == -1) {
      return Center(child: CircularProgressIndicator());
    } else if (_iQtIcons == 0) {
      return _showEmpty();
    }
    return _listIcons(type);
  }

  Widget _listIcons(String type) {
    //return Container(//height: MediaQuery.of(context).size.height-40,
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Wrap(
          spacing: 10,
          children: _buildIconList(type),
        )
      ]),
    );
  }

  List<Widget> _buildIconList(String type) {
    List<Widget> llIcons = <Widget>[];
    Map<String, IconData> _mIconsList;

    if(type=='find'){
      _mIconsList = _mIconsFind;
    }else{
      _mIconsList = _iconCollection;
    }
    _mIconsList.forEach((lsName, loIcon) {
      Widget loIten = IconButton(
        padding: EdgeInsets.all(15),
        onPressed: () => addUserIcon(lsName, loIcon.codePoint, loIcon.fontFamily, loIcon.fontPackage),
        icon: Icon(
          loIcon,
          size: 35,
        ),
      );

      llIcons.add(loIten);
    });

    return llIcons;
  }

  Widget _showEmpty() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0, 0),
          child: Icon(
            Icons.apps,
            size: 50,
          ),
        ),
      ],
    );
  }

  void _search() {
    String lsQuery = _oCtrlSearchQuery.text;

    if (lsQuery.length > 2) {
      lsQuery.toLowerCase();

      setState(() {
        _mIconsFind.clear();

        _iconCollection.forEach((lsName, loIcon) {
          if (lsName.toLowerCase().contains(lsQuery)) {
            _mIconsFind[lsName] = loIcon;
          }
        });

        _iQtFindIcons = _mIconsFind.length;
        if (_iQtFindIcons > 0) {
          _mIconsShow.clear();
          _mIconsShow.addAll(_mIconsFind);
          _iQtIcons = _mIconsShow.length;
        }
      });
    }
  }
}
