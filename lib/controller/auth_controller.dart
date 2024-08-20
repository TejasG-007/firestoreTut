import 'package:firabasetut/service/firebase_auth_service.dart';
import 'package:firabasetut/service/network_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final NetworkService _networkService = NetworkService();

  RxBool isLoading = false.obs;

  Future<(FirebaseAuthExceptionEnum,User?)> loginUser(String userName, String password)async{
    return await _firebaseAuthService.authUser(userName, password);
  }

  Future<(FirebaseAuthExceptionEnum,User?)> registerUser(String userName, String password)async{
    return await _firebaseAuthService.registerUser(userName, password);
  }


}