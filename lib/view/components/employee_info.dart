import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';
import '../../code/resource/validator.dart';
import '../../view_model/bloc/auth/auth_cubit.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'custom_texts.dart';

class EmployeeInfo extends StatefulWidget {
  const EmployeeInfo({Key? key}) : super(key: key);

  @override
  State<EmployeeInfo> createState() => _EmployeeInfoState();
}

class _EmployeeInfoState extends State<EmployeeInfo> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController chronicDiseases = TextEditingController();
  TextEditingController address = TextEditingController();

  bool showPassword = true;
  int selectedValue = 1;
  String dropdownvalue = 'User';

  RegExp regExp = RegExp(r"^[0-9]{2}$", caseSensitive: false);

// List of items in our dropdown menu
  var items = [
    'User',
    'Employee',
  ];
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.text = '';
    passwordController.text = '';
    nameController.text = '';
    ageController.text = '';
    descriptionController.text = '';
    phoneController.text = '';
    chronicDiseases.text = '';
    address.text = '';

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Form(
          key: formKey,
          child: Column(
            children: [
              text(text: 'Email'),
              CustomTextField(
                controller: emailController,
                fieldValidator: emailValidator,
                hint: 'Email',
                iconData: Icons.email,
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 20,
              ),
              text(text: 'Name'),
              CustomTextField(
                controller: nameController,
                fieldValidator: (String value) {
                  if (value.trim().isEmpty || value == ' ') {
                    return 'This field is required';
                  }
                  if (!RegExp(r'^[a-zA-Z]+(\s[a-zA-Z]+)?$').hasMatch(value)) {
                    return 'please enter only two names with one space';
                  }
                  if (value.length < 3 || value.length > 32) {
                    return 'First name must be between 2 and 32 characters';
                  }
                },
                hint: 'name',
                iconData: Icons.perm_identity,
              ),

              const SizedBox(
                height: 20,
              ),

              text(text: 'Address'),
              CustomTextField(
                controller: address,
                fieldValidator: (String value) {
                  if (value.trim().isEmpty || value == ' ') {
                    return 'This field is required';
                  }
                },
                hint: 'Address',
                iconData: Icons.location_city,
              ),

              const SizedBox(
                height: 20,
              ),
              text(text: 'Description'),
              CustomTextField(
                controller: descriptionController,
                fieldValidator: (String value) {
                  if (value.trim().isEmpty || value == ' ') {
                    return 'This field is required';
                  }
                },
                hint: 'Description',
                maxLine: 3,
                iconData: Icons.description,
              ),

              const SizedBox(
                height: 20,
              ),
              text(text: 'Phone'),
              CustomTextField(
                textInputType: TextInputType.phone,
                controller: phoneController,
                fieldValidator: phoneValidator,
                hint: 'phone',
                iconData: Icons.phone,
              ),
              const SizedBox(
                height: 20,
              ),
              (state is RegisterLoadingState)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomButton(
                      function: () {
                        // i validate if user Enter all data and then
                        // send data to BackEnd
                        if (formKey.currentState!.validate()) {
                          cubit.registerEmploy(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                              phone: phoneController.text,
                              name: nameController.text,
                              address: address.text,
                              description: descriptionController.text,
                              role: '2', // will change
                        );
                        }
                      },
                      color: darkorange,
                      widget: const Text("Register"),
                      size: Size(300.w, 50.h),
                      radius: 20.r,
                      disable: true,
                    )
            ],
          ),
        );
      },
    );
  }
}
