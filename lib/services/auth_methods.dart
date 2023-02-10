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
          'valve1': {
            'state': false,
            'time': 5,
            'days': [0, 1, 2, 3, 4, 5, 6],
            'times': List.generate(39, (index) => 0),
            'title': 'Valve 1',
            'turnOnEvery': 3,
            'type': 'Programado'
          },
          'valve2': {
            'state': false,
            'time': 5,
            'days': [0, 1, 2, 3, 4, 5, 6],
            'times': List.generate(39, (index) => 0),
            'title': 'Valve 2',
            'turnOnEvery': 3,
            'type': 'Programado'
          },
          'valve3': {
            'state': false,
            'time': 5,
            'days': [0, 1, 2, 3, 4, 5, 6],
            'times': List.generate(39, (index) => 0),
            'title': 'Valve 3',
            'turnOnEvery': 3,
            'type': 'Programado'
          },
          'valve4': {
            'state': false,
            'time': 5,
            'days': [0, 1, 2, 3, 4, 5, 6],
            'times': List.generate(39, (index) => 0),
            'title': 'Valve 4',
            'turnOnEvery': 3,
            'type': 'Programado'
          },
        });
        isSignedIn = true;
      }
    } catch (err) {
      return isSignedIn;
    }
    return isSignedIn;
  }
}
