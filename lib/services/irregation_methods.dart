import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:irregation_proyect/models/irregation.dart';
import 'package:irregation_proyect/models/user.dart' as model;

String url = 'https://emp-irrigation-proyect-default-rtdb.firebaseio.com/';
final FirebaseAuth auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref();

class IrregatiobMethods {
  static Future<Irregation?> getIrrigation() async {
    String user = auth.currentUser?.uid ?? '';
    final snapshot = await ref.child('$user/data').get();
    try {
      if (snapshot.exists) {
        return Irregation.fromJson(snapshot.value as Map<dynamic, dynamic>);
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }

  //update
  static Future<void> updateValve(Valve valve, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text').set(valve.toJson());
  }

  //UPDATE STADO
  static Future<void> updateState(bool state, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text/state').set(state);
  }

  //updateTitle
  static Future<void> updateTitle(String title, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text/title').set(title);
  }

  //UPDATE weeks
  static Future<void> updateWeeks(int position, int weeks, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text/days/$position').set(weeks);
  }

  //update time
  static Future<void> updateTime(int time, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text/time').set(time);
  }

  //updateProgrammingType
  static Future<void> updateType(String programmingType, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text/type').set(programmingType);
  }

  //update updateTurnOnEvery
  static Future<void> updateTurnOnEvery(int turnOnEvery, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text/turnOnEvery').set(turnOnEvery);
  }

  //UPDATE times
  static Future<void> updateTimes(int position, int times, String text) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/$text/times/$position').set(times);
  }

  //update isTemperature
  static Future<void> updateTemperature(int isTemperature) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/isTemperature').set(isTemperature);
  }

  //UPDATE CALEFACTOR
  static Future<void> updateHeater(int heater) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/isHeater').set(heater);
  }

  //update isActive
  static Future<void> updateActive(bool isActive) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/isActive').set(isActive);
  }

  //GET USER
  static Future<model.User?> getUser() async {
    String user = auth.currentUser?.uid ?? '';
    final snapshot = await ref.child('$user/user').get();
    try {
      if (snapshot.exists) {
        return model.User.fromJson(snapshot.value as Map<dynamic, dynamic>);
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
    return null;
  }

  static Future<void> updateUser(model.User user) async {
    String id = auth.currentUser?.uid ?? '';
    await ref.child('$id/user').set(user.toJson());
  }

  //get datos de datos data/dayX
  static Future<List<int>> getDays(
    String day,
  ) async {
    String user = auth.currentUser?.uid ?? '';
    final snapshot = await ref.child('$user/data/$day').get();
    try {
      if (snapshot.exists) {
        List<int> days = [];
        for (var item in snapshot.value as List<dynamic>) {
          days.add(item as int);
        }
        return days;
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
    return [];
  }
}
