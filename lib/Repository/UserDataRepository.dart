import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app2/Entity/User.dart';

class UserDataRepository {
  final _userReference = FirebaseDatabase.instance.reference().child("User");

  Future<void> registerUser(User user) async {
    try {
      await _userReference.child(user.userId).set(user.toJson());
    } catch (e) {
      print(e);
    }
  }
}
