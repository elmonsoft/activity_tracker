import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'modell.g.dart';

const String activityBox = "activities";
const String activitySetupBox = "activity_setup";


@HiveType(typeId: 0)
class Activity with Comparable<Activity>, Compare<Activity> {
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

  String getDiff(){
    int diff = begin.difference(last).inMinutes;
    int min = diff % 60;
    int hours = (diff/60).toInt()%24;
    int days = (diff/60/24).toInt();
    String sdays = days==0?'':'$days days ';
    String shours = (days==0 && hours==0)?'':'$hours hours ';
    String zeit = '$sdays $shours $min minutes';
    if (days==0 && hours==0 && min==0) return '';
    return '$sbegin  --> $zeit';

  }
}


@HiveType(typeId: 1)
class ActivitySetup  with Comparable<ActivitySetup>, Compare<ActivitySetup>{
  @HiveField(0)
  String name;
  @HiveField(1)
  int icolor;
  @HiveField(2)
  Map micon; // Icon(IconData(micon['codePoint'], fontFamily: micon['fontFamily']), size: 30,)

  ActivitySetup({this.name,  this.icolor, this.micon});

  @override
  String toString() {
    return '$name / color: $icolor / icon: $micon';
  }

  @override
  int compareTo(ActivitySetup other) =>
      (name).compareTo(other.name);

}


mixin Compare<T> on Comparable<T> {
  bool operator <=(T other) => this.compareTo(other) <= 0;

  bool operator >=(T other) => this.compareTo(other) >= 0;

  bool operator <(T other) => this.compareTo(other) < 0;

  bool operator >(T other) => this.compareTo(other) > 0;

  bool operator ==(other) => other is T && this.compareTo(other) == 0;
}