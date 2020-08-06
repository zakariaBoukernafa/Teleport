import 'package:firebase_auth/firebase_auth.dart';

import '../../services/database.dart';

class AuthService {
  //initiate FireBaseAuth and fireStore instances for later use

  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseService writedb = new DatabaseService();

  FirebaseUser _user;

  FirebaseUser get user => _user;

  String verificationId;

  //signUp data for database

  Future<FirebaseUser> signUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    this._user = result.user;
    return this._user;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  Future databaseSignUp(
      FirebaseUser user, String userName, String robotId) async {
    writedb.createUser(user.uid, userName, user.email, robotId, false);
  }

  Future robotUpdate(String user, String robotId)async{
    writedb.updateRobotId(user, robotId);
  }

  //get the currentUser's id
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  Future<String> getUserID() async {
    try {
      return (await _auth.currentUser()).uid;
    } catch (e) {

      print("error getting user");
    }
  }

  Future <void> resetPasswordSend(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("password reset error");
      print(e);
    }
  }

  Future<void> confirmPasswordChange(String oobCode, String newPassword)async{
    try{
      await _auth.confirmPasswordReset(oobCode, newPassword);
    }
    catch(e){
      print("confirmation error");
      print(e);
    }
  }

  //sign out the user
  Future<void> signOut() async {
    return (await _auth.signOut());
  }



}
