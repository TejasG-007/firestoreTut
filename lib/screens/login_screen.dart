import 'package:firabasetut/controller/auth_controller.dart';
import 'package:firabasetut/screens/register_screen.dart';
import 'package:firabasetut/service/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("LOGIN VIEW"),
          const SizedBox(height: 50,),
          Container(
            margin: const EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
              children: [
                TextFormField(
                  validator: (val){
                    if(val!.isEmpty){
                      return "Username should not be Empty.";
                    }
                    return null;
                  },
                  controller: _username,
                  decoration: InputDecoration(
                    hintText: "UserName",
                    label: const Text("UserName"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                TextFormField(
                  controller: _password,
                  validator: (val){
                    if(val!.isEmpty){
                      return "Password should not be Empty.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    label: const Text("Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              ],
            )),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: ()async{
                if(_formKey.currentState!.validate()){
                await _authController.loginUser(
                    _username.text, _password.text).then((state){
                      if(state.$1==FirebaseAuthExceptionEnum.userNotFound){
                        notRegisteredSnackBar();
                      }
                      else if(state.$1==FirebaseAuthExceptionEnum.success&&state.$2!=null){
                        _navigateToHomeScreen(state.$2!);
                      }
                      else{
                        showErrorsBasedOnException(state.$1);
                      }
                });}
              }, child:const Text("Login",style: TextStyle(color: Colors.white),)),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(child: const Text("Not Registered?"),onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RegisterScreen()));
              },)
            ],
          )
        ],
      ))
    );
  }
  _navigateToHomeScreen(User user){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen(user)));
  }
  notRegisteredSnackBar(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
        const Text("Not Registered"), TextButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const RegisterScreen()));
        }, child: const Text("Register"))
      ],)));
  }

  void showErrorsBasedOnException(FirebaseAuthExceptionEnum state) {
    switch(state){
      case FirebaseAuthExceptionEnum.invalidEmail:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR! Invalid Email"),
          backgroundColor: Colors.red,
        ));
        break;
      case FirebaseAuthExceptionEnum.wrongPassword:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR! Wrong Password"),
          backgroundColor: Colors.red,
        ));
        break;
      case FirebaseAuthExceptionEnum.userDisabled:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR! User is Disabled"),
          backgroundColor: Colors.red,
        ));
        break;
      case FirebaseAuthExceptionEnum.error:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR!"),
          backgroundColor: Colors.red,
        ));
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR!"),
          backgroundColor: Colors.red,
        ));
        break;
    }
  }
}
