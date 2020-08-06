import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:teleport/modes/users/userdb.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final FirebaseDatabase _realTimedb = FirebaseDatabase.instance;

  /// Get a stream of a single document
  Stream<Users> streamUsers(String id) {
    return _db
        .collection('Users')
        .document(id)
        .snapshots()
        .map((snap) => Users.fromMap(snap.data));
  }

  Future<String> getCurrentUser(String robotId) async {
    String userId;
    await _realTimedb.reference().child(robotId).child("user").once().then((
        DataSnapshot snapshot) {
      userId = snapshot.value;
    });
    return userId;
  }


  Future<void> disconnectUser(String robotId) async {
    print(robotId);
    _realTimedb.reference().child(robotId).set({
      'user': null,
    });
  }



  /// Write data with no profile picture
  Future<void> createUser(String userid, String username,String email, String robotId,
      bool isEmailVerified) {
    return _db.collection('Users').document(userid).setData({
      'username': username,
      'email': email,
      'profilePicture':
          "https://firebasestorage.googleapis.com/v0/b/taslim-84f8f.appspot.com/o/default.png?alt=media&token=920235a1-c532-43fc-840c-e31993623f5a",
      'robotId': robotId,
      'userId': userid,
      'isEmailVerified': isEmailVerified
    });
  }

  Future<void> createUserWithProfilePicture(String userid, String username,
      String email, String profilePicture, int rating, bool isEmailVerified, String robotId) {
    return _db.collection('Users').document(userid).setData({
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'robotId': robotId,
      'isEmailVerified': isEmailVerified
    });
  }

  Future<void> updateProfilepicture(String userid, String photoUrl) {
    return _db
        .collection('Users')
        .document(userid)
        .updateData({'profilePicture': photoUrl});
  }

  Future<void> updateEmailVerification(String userid, bool isEmailVerified) {
    return _db
        .collection('Users')
        .document(userid)
        .updateData({'isEmailVerified': isEmailVerified});
  }

  bool isUserExists(String phoneNumber) {
    bool result = false;
    _db
        .collection("Users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .snapshots()
        .listen(((data) {
      try {
        print('grower ${data.documents[0]["phoneNumber"]}');
        result = data.documents[0]["phoneNumber"] == phoneNumber;
      } catch (e) {
        print('phone number doesnt exist');
        result = false;
      }
      print('result $result');
    }));
    return result;
  }

  Future<void> updateRobotId(String userId, String robotId){
    return _db.collection('Users').document(userId).updateData({'robotId': robotId});
  }

}
