import 'package:flutter/material.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view/pages/auth/login_screen.dart';
import 'package:graduation_project/view/pages/auth/register_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomButton(widget: const Text("Sign in"),
              function: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginScreen();
            },));
              }, disable: true,color: Colors.black),
          CustomButton(widget: const Text("Sign up"),
              function: (){
            return RegisterScreen();
              }, color: Colors.black,
              disable: true)
        ],
      )
    );
  }
}
