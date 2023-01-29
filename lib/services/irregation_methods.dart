import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:irregation_proyect/models/irregation.dart';

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
}
