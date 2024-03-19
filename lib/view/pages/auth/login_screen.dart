import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';
import 'package:graduation_project/view/pages/auth/register_screen.dart';
import 'package:graduation_project/view/pages/employee_pages/layout_employee.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import '../../../code/resource/validator.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../components/custom_texts.dart';
import '../admin_screen/layout_admin.dart';
import '../user/layout_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // for validation
  TextEditingController emailController = TextEditingController(); // for email
  TextEditingController passwordController =
  TextEditingController(); // for password
  bool showPassword = true; // for show password

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccessfulState) {
          String? token = CacheHelper.getDataString(key: 'id');
          if (state.role == '1') {
            if (state.ban) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are banned'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(token)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (!snapshot.data!['ban']) {
                            return const LayOutScreenAdmin();
                          } else {
                            CacheHelper.removeData(key: 'id');
                            return LoginScreen();
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      });
                },
              ), (route) => false);
            }
          } else if (state.role == '2') {
            if (state.ban) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are banned'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              if (state.approved) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(token)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData) {
                            if (!snapshot.data!['ban']) {
                              return const LayoutEmployee();
                            } else {
                              CacheHelper.removeData(key: 'id');
                              return LoginScreen();
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        });
                  },
                ), (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Waiting admin approve'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
            print('adham 2');
          } else {
            if (state.ban) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are banned'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(token)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (!snapshot.data!['ban']) {
                            return const LayoutScreen();
                          } else {
                            CacheHelper.removeData(key: 'id');
                            return LoginScreen();
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      });
                },
              ), (route) => false);
            }
          }
        } else {
          if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 250.h,
                          width: 300.w,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w900),
                        ),
                        text(text: 'Email'),
                        CustomTextField(

                          controller: emailController,
                          fieldValidator: emailValidator,
                          hint: 'Email',
                          iconData: Icons.email,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        text(text: 'Password'),
                        CustomTextField(
                          controller: passwordController,
                          fieldValidator: passwordValidator,
                          hint: 'Password',
                          iconData: Icons.lock,
                          password: showPassword,
                          passwordTwo: true,
                          function: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        (state is LoginLoadingState)
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : CustomButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              authCubit.login(
                                email: emailController.text.trim(),
                                password: passwordController.text,
                              );
                            }
                          },
                          color: darkorange,
                          widget: Text("LOGIN"),
                          size: Size(300.w, 50.h),
                          radius: 20.r,
                          disable: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don’t have an account?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ));
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: darkorange),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}