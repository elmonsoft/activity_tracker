import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'modell.g.dart';

User favoriteUser; // global usage
String activityBox = "activities"; // global usage
String activitySetupBox = "activity_setup"; // global usage
const String usersBox = "users";
const String appSetupBox = "app_setup";
const String defaultActivityBox = "activities";
const String defaultActivitySetupBox = "activity_setup";
const String iconsBox = "user_icons";
const String iconsCollectionBox = "user_icons_collection";

//
// Activity
//
@HiveType(typeId: 0)
class Activity extends HiveObject with Comparable<Activity>, Compare<Activity> {
  final formatter = DateFormat("E dd.MM.yyyy HH:mm");

  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime begin;
  @HiveField(2)
  DateTime last;
  @HiveField(3)
  int icolor;
  @HiveField(4)
  Map micon; // Icon(IconData(micon['codePoint'], fontFamily: micon['fontFamily']), size: 30,)

  Activity({this.name,  this.begin, this.last, this.icolor, this.micon});

  @override
  String toString() {
    return '$name / begin: $sbegin / last: $slast} '; //\nColor: $icolor / Icon: $micon ';
  }

  @override
  int compareTo(Activity other) =>
      (other.begin).compareTo(begin);


  String get sbegin => (begin??'')==''?'':formatter.format(begin??'');
  String get slast => (last??'')==''?'':formatter.format(last??'');
  String get sdiff => getDiff();
  Map get mapIcon => micon;
  int get intColor => icolor;

  String getDiff(){
    int diff = begin.difference(last).inMinutes;
    int min = diff % 60;
    int hours = (diff~/60)%24;
    int days = diff~/60~/24;
    double ddays = days + hours/24;
    String sdays = days==0?'':'$days day ';
    String shours = (days==0 && hours==0)?'':(hours==1)?'$hours hour ':'$hours hours ';
    String smin = (min==1)?'$min minute':'$min minutes';
    String zeit = '$sdays $shours $smin ';
    if (days==0 && hours==0 && min==0) return sbegin;
    if(days==0 && hours>16 || days>1){
      zeit = '${ddays.toStringAsFixed(2)} days';
    }

    return '$sbegin  --> $zeit';

  }
}

//
// ActivitySetup
//
@HiveType(typeId: 1)
class ActivitySetup extends HiveObject with Comparable<ActivitySetup>, Compare<ActivitySetup>{
  @HiveField(0)
  String name;
  @HiveField(1)
  int icolor;
  @HiveField(2)
  Map micon; // Icon(IconData(micon['codePoint'], fontFamily: micon['fontFamily']), size: 30,)
  @HiveField(3)
  bool favorite;

  bool _filter=false; // no HiveField

  ActivitySetup({this.name,  this.icolor, this.micon, this.favorite=false});

  @override
  String toString() {
    return '$name / favorite: $favorite / filter: $_filter '; // color: $icolor / icon: $micon';
  }

  @override
  int compareTo(ActivitySetup other) =>
      (name).compareTo(other.name);

  bool get filter => _filter;
  set filter(bool value) => _filter = value;
}

//
// User
//
@HiveType(typeId: 2)
class User extends HiveObject with Comparable<User>, Compare<User>{
  @HiveField(0)
  String name;
  @HiveField(1)
  int icolor;
  @HiveField(2)
  Map micon; // Icon(IconData(micon['codePoint'], fontFamily: micon['fontFamily']), size: 30,)
  @HiveField(3)
  bool favorite;
  @HiveField(4)
  String activityBox;
  @HiveField(5)
  String activitySetupBox;

  User({this.name,  this.icolor, this.micon, this.favorite=false,
        this.activityBox, this.activitySetupBox});

  @override
  String toString() {
    return '$name / favorite: $favorite  '; // color: $icolor / icon: $micon';
  }

  @override
  int compareTo(User other) =>
      (name).compareTo(other.name);

}


//
// Icon
//
@HiveType(typeId: 3)
class UserIcon  extends HiveObject with Comparable<UserIcon>, Compare<UserIcon> {
  @HiveField(0)
  String name;
  @HiveField(1)
  int codePoint;
  @HiveField(2)
  String fontFamily;
  @HiveField(3)
  Map micon; // Icon(IconData(micon['codePoint'], fontFamily: micon['fontFamily']), size: 30,)

  UserIcon({this.name,  this.codePoint, this.fontFamily, this.micon});

  @override
  String toString() {
    return '$name  ';
  }

  @override
  int compareTo(UserIcon other) =>
      (name).compareTo(other.name);

}

mixin Compare<T> on Comparable<T> {
  bool operator <=(T other) => this.compareTo(other) <= 0;

  bool operator >=(T other) => this.compareTo(other) >= 0;

  bool operator <(T other) => this.compareTo(other) < 0;

  bool operator >(T other) => this.compareTo(other) > 0;

  bool operator ==(other) => other is T && this.compareTo(other) == 0;
}