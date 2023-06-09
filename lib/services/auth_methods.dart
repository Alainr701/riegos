import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:irregation_proyect/models/user.dart' as model;

final FirebaseAuth _auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref();

class AuthMethods {
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    bool isSignedIn = false;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        isSignedIn = true;
      }
    } catch (err) {
      return isSignedIn;
    }
    return isSignedIn;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required bool state,
    required int age,
    required String phone,
  }) async {
    bool isSignedIn = false;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        final UserCredential result =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String user = result.user?.uid ?? '';

        final usuario = model.User(
          uid: user,
          name: name,
          email: email,
          state: state,
          phone: int.parse(phone),
          age: age,
          type: 'Usuario',
        );
        await ref.child('$user/user').set(usuario.toJson());
        await ref.child('$user/data').set({
          'isTemperature': 0,
          'isActive': false,
          'temperature': 0,
          'isHeater': 0,
          'valve1': {
            'state': false,
            'daysRegation': [1],
            'time': 5,
            'days': [0, 1, 2, 3, 4, 5, 6],
            'times': List.generate(39, (index) => 0),
            'title': 'Valve 1',
            'turnOnEvery': 3,
            'type': 'Programado'
          },
          'valve2': {
            'state': false,
            'daysRegation': [1],
            'time': 5,
            'days': [0, 1, 2, 3, 4, 5, 6],
            'times': List.generate(39, (index) => 0),
            'title': 'Valve 2',
            'turnOnEvery': 3,
            'type': 'Programado'
          },
          'valve3': {
            'daysRegation': [1],
          },
          'valve4': {
            'daysRegation': [1],
          }
        });
        isSignedIn = true;
      }
    } catch (err) {
      return isSignedIn;
    }
    return isSignedIn;
  }

  //delete with only email
  static Future<bool> deleteUser({
    required String email,
  }) async {
    bool isSignedIn = false;
    try {
      if (email.isNotEmpty) {
        await ref.child('${_auth.currentUser?.uid}').remove();
        isSignedIn = true;
      }
    } catch (err) {
      return isSignedIn;
    }
    return isSignedIn;
  }

  //get all users
  static Future<List<model.User>> getUsers() async {
    print('getUsers');
    List<model.User> users = [];
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = json.decode(json.encode(snapshot.value));
        data.forEach((key, value) {
          if (key != 'Administrador') {
            users.add(model.User.fromJson(value['user']));
          }
        });
        return users;
      } else {
        print('No data available.');
      }
    } catch (err) {
      print(err);
      return users;
    }
    return users;
  }

  //update state user
  static Future<bool> updateStateUser({
    required String uid,
    required bool state,
  }) async {
    bool isSignedIn = false;
    try {
      if (uid.isNotEmpty) {
        await ref.child('$uid/user/state').set(state);
        isSignedIn = true;
      }
    } catch (err) {
      return isSignedIn;
    }
    return isSignedIn;
  }
}
