import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../code/resource/validator.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
class CreateAdmin extends StatefulWidget {
  const CreateAdmin({Key? key}) : super(key: key);

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  bool showPassword = false;
  List<String> gender = ['Male' , 'Female'];
  String? selectedValue;
  RegExp regExp = RegExp(r"^[0-9]{2}$", caseSensitive: false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is RegisterSuccessfulState){
          // AuthCubit.get(context).getAdmin();
          Navigator.maybePop(context);
        }
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 200.h,
                        width: 200.w,
                      ),
                      const Text("Create New Admin",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900),),
                      CustomTextField(
                        controller: emailController,
                        fieldValidator: emailValidator,
                        hint: 'email',
                        iconData: Icons.email,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        fieldValidator: passwordValidator,
                        hint: 'Password',
                        iconData: Icons.lock,
                        password: showPassword,
                        passwordTwo: true,
                        function: (){
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                        controller: nameController,
                        fieldValidator: (String value) {
                          if (value.trim().isEmpty || value == ' ') {
                            return 'This field is required';
                          }
                          if (!RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)?$')
                              .hasMatch(value)) {
                            return 'please enter only two names with one space';
                          }
                          if (value.length < 3 || value.length > 32) {
                            return 'First name must be between 2 and 32 characters';
                          }
                        },
                        hint: 'name',
                        iconData: Icons.perm_identity,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                        FaIcon(FontAwesomeIcons.marsAndVenus , color: Colors.grey,),
                          SizedBox(width: 20.w,),
                          SizedBox(
                            width: 350.w,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  'Select Item',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                  ),
                                ),
                                items: gender
                                    .map((item) =>
                                    DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value as String;
                                  });
                                },
                                buttonHeight: 40,
                                buttonWidth: 140,
                                itemHeight: 40,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                        textInputType: TextInputType.number,
                        controller: ageController,
                        fieldValidator: (String value) {
                          if (value.isEmpty) {
                            return "age is required";
                          } else if (regExp.hasMatch(value) == false) {
                            return "number only";
                          } else if (int.parse(value) < 0 && int.parse(value) < 100) {
                            return "please enter valid age";
                          }
                        },
                        hint: 'age',
                        iconData: Icons.date_range,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                        textInputType: TextInputType.phone,
                        controller: phoneController,
                        fieldValidator: phoneValidator,
                        hint: 'phone',
                        iconData: Icons.phone,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      (state is RegisterLoadingState)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : CustomButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            authCubit.register(
                               gender: selectedValue.toString(),
                                email: emailController.text.trim(),
                                password: passwordController.text,
                                phone: phoneController.text,
                                name: nameController.text,
                                age: ageController.text,
                                role: '1'
                            ).then((value) {

                            });
                          }
                        },
                        widget: Text("Register"),
                        size: Size(300.w, 50.h),
                        radius: 20.r,
                        disable: true,
                      )
                    ],
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
