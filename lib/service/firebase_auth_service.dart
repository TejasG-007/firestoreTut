import 'package:firabasetut/service/firebase_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum FirebaseAuthExceptionEnum {
  emailAlreadyInUse("email-already-in-use"),
  invalidEmail("invalid-email"),
  weakPassword("weak-password"),
  operationNotAllowed("operation-not-allowed"),
  success("success"),
  userDisabled("user-disabled"),
  userNotFound("user-not-found"),
  wrongPassword("wrong-password"),
  error("error");

  final String value;
  const FirebaseAuthExceptionEnum(this.value);
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDbService _firebaseDbService = FirebaseDbService();







  Future<(FirebaseAuthExceptionEnum, User?)> authUser(
      String username, String password) async {
    try {
      final UserCredential response = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      if (response.user != null) {
        return (FirebaseAuthExceptionEnum.success, response.user);
      }
      return (FirebaseAuthExceptionEnum.error, null);
    } on FirebaseAuthException catch (error) {
      if (error.code == FirebaseAuthExceptionEnum.wrongPassword.value) {
        return (FirebaseAuthExceptionEnum.wrongPassword, null);
      } else if (error.code == FirebaseAuthExceptionEnum.userDisabled.value) {
        return (FirebaseAuthExceptionEnum.userDisabled, null);
      } else if (error.code == FirebaseAuthExceptionEnum.userNotFound.value) {
        return (FirebaseAuthExceptionEnum.userNotFound, null);
      }
      if (error.code == FirebaseAuthExceptionEnum.invalidEmail.value) {
        return (FirebaseAuthExceptionEnum.invalidEmail, null);
      } else {
        return (FirebaseAuthExceptionEnum.error, null);
      }
    }
  }

  Future<(FirebaseAuthExceptionEnum, User?)> registerUser(
      String username, String password) async {
    try {
      final UserCredential response = await _auth
          .createUserWithEmailAndPassword(email: username, password: password);
      if (response.user != null) {
        await _firebaseDbService.createDatabaseForUser(username);
        return (FirebaseAuthExceptionEnum.success, response.user);
      }
      return (FirebaseAuthExceptionEnum.error, null);
    } on FirebaseAuthException catch (error) {
      if (error.code == FirebaseAuthExceptionEnum.emailAlreadyInUse.value) {
        return (FirebaseAuthExceptionEnum.emailAlreadyInUse, null);
      } else if (error.code == FirebaseAuthExceptionEnum.weakPassword.value) {
        return (FirebaseAuthExceptionEnum.weakPassword, null);
      } else if (error.code ==
          FirebaseAuthExceptionEnum.operationNotAllowed.value) {
        return (FirebaseAuthExceptionEnum.operationNotAllowed, null);
      }
      if (error.code == FirebaseAuthExceptionEnum.invalidEmail.value) {
        return (FirebaseAuthExceptionEnum.invalidEmail, null);
      } else {
        return (FirebaseAuthExceptionEnum.error, null);
      }
    }
  }
}
