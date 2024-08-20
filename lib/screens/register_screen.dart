import 'package:firabasetut/controller/auth_controller.dart';
import 'package:firabasetut/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/firebase_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _validationReg = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("REGISTER VIEW"),
        const SizedBox(
          height: 50,
        ),
        Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _validationReg,
              child: Column(
            children: [
              TextFormField(
                controller: _username,
                validator: (username){
                  if(username!.isEmpty){
                    return "UserName/email should not be empty";
                  } else if(!username.contains("@")){
                    return "UserName/email is invalid";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "UserName/Email",
                    label: const Text("UserName/Email"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _password,
                validator: (password){
                  if(password!.isEmpty){
                    return "Password should not be empty";
                  }else if(password.length<8){
                    return "Password is weak";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Password",
                    label: const Text("Password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ],
          )),
        ),
        const SizedBox(
          height: 30,
        ),
        Obx(
          ()=> AnimatedContainer(
            duration: const Duration(seconds: 1),
            child: _authController.isLoading.value?const LinearProgressIndicator():ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  if(_validationReg.currentState!.validate()){
                    _authController.isLoading.value = true;
                    await _authController
                        .registerUser(_username.text, _password.text)
                        .then((user) {
                      _authController.isLoading.value = false;
                      gotoLoginScreen(user.$1);
                    });
                  }
                  _username.clear();
                  _password.clear();
                  _authController.isLoading.value = false;
                },
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text("Already Registered?"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
            )
          ],
        )
      ],
    )));
  }

  void gotoLoginScreen(FirebaseAuthExceptionEnum state) {
    switch (state) {
      case FirebaseAuthExceptionEnum.invalidEmail:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR! Invalid Email"),
          backgroundColor: Colors.red,
        ));
        break;
      case FirebaseAuthExceptionEnum.emailAlreadyInUse:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR! Email Already in Use"),
          backgroundColor: Colors.red,
        ));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginScreen()));
        break;
      case FirebaseAuthExceptionEnum.weakPassword:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR! Weak Password"),
          backgroundColor: Colors.red,
        ));
        break;
      case FirebaseAuthExceptionEnum.error:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR!"),
          backgroundColor: Colors.red,
        ));
        break;
      case FirebaseAuthExceptionEnum.success:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registered.."),
          backgroundColor: Colors.green,
        ));
      default:
        break;
    }
  }
}
