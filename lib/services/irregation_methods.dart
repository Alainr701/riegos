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

  //update isTemperature
  static Future<void> updateTemperature(int isTemperature) async {
    String user = auth.currentUser?.uid ?? '';
    await ref.child('$user/data/isTemperature').set(isTemperature);
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
}
