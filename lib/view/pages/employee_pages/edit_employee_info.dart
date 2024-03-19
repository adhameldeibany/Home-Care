import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/view/components/custom_text_field.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';

import '../../../code/resource/validator.dart';
import '../../components/custom_button.dart';

class EditHomecareScreen extends StatefulWidget {
  const EditHomecareScreen({Key? key}) : super(key: key);

  @override
  State<EditHomecareScreen> createState() => _EditHomecareScreenState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();

TextEditingController passwordController = TextEditingController();

TextEditingController nameController = TextEditingController();

TextEditingController addressController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

TextEditingController phoneController = TextEditingController();
bool showPassword = false;
bool enable = false;
class _EditHomecareScreenState extends State<EditHomecareScreen> {
  @override
  void initState() {
    // TODO: implement initState
    nameController.text = AuthCubit.get(context).userModel!.name;
    phoneController.text = AuthCubit.get(context).userModel!.phone;
    emailController.text = AuthCubit.get(context).userModel!.email;
    addressController.text = AuthCubit.get(context).userModel!.address;
    descriptionController.text = AuthCubit.get(context).userModel!.description;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);

        return Scaffold(
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: (state is GetUserDataLoadingState)
                ?const Center(
              child: CircularProgressIndicator(),
            )
                : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100.r,
                      backgroundImage: NetworkImage((authCubit
                          .userModel!.photo ==
                          '')
                          ? 'https://firebasestorage.googleapis.com/v0/b/graduation-project-8eccc.appspot.com/o/p2.png?alt=media&token=a64ac41e-716c-4843-9513-67b123ffd868'
                          : authCubit.userModel!.photo),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround
                      ,children: [
                      (state is UploadImageStateLoading)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : CustomButton(
                        disable: true,
                        size: Size(170.w,40.h),
                        widget: const Text("Select from gallery"),
                        function: () {
                          AuthCubit.get(context)
                              .pickImageGallary(context);
                        },
                      ),

                      (state is UploadImageStateLoading)
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          :  CustomButton(
                        size: Size(170.w,40.h),

                        disable: true,
                        widget: const Text("Select from camera"),
                        function: () {
                          AuthCubit.get(context)
                              .pickImageCamera(context);
                        },
                      ),

                    ],),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: emailController,
                            fieldValidator: emailValidator,
                            hint: 'Email',
                            iconData: Icons.email,
                            enable: false,
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
                            enable: enable,
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
                            enable: enable,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            controller: addressController,
                            fieldValidator: (String ?value){
                              if(value!.isEmpty){
                                return 'This field is required';
                              }
                            },
                            hint: 'Address',
                            iconData: FontAwesomeIcons.locationCrosshairs,
                            enable: enable,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextField(
                            textInputType: TextInputType.text,
                            controller: descriptionController,
                            fieldValidator: (String ?value){
                              if(value!.isEmpty){
                                return 'This field is required';
                              }
                            },
                            hint: 'Description',
                            iconData: FontAwesomeIcons.noteSticky,
                            enable: enable,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             (state is RegisterLoadingState)
                                 ? const Center(
                               child: CircularProgressIndicator(),
                             )
                                 : CustomButton(
                               function: () {
                                 setState(() {
                                   enable = !enable;
                                 });
                               },
                               widget: const Text("Start Edit"),
                               size: Size(150.w, 50.h),
                               radius: 20.r,
                               disable: !enable,
                             ),
                             (state is UpdateDataLoadingState)
                                 ? const Center(
                               child: CircularProgressIndicator(),
                             )
                                 : CustomButton(
                               function: () {
                                 if (formKey.currentState!.validate()) {
                                   AuthCubit.get(context).update(
                                       email: emailController.text,
                                       phone: phoneController.text,
                                       age: '',
                                       description: descriptionController.text,
                                       address: addressController.text,
                                       name: nameController.text).then((value) {

                                   }).then((value) {
                                     enable = false;
                                   });
                                 }
                               },
                               widget: const Text("confirm Update"),
                               size: Size(150.w, 50.h),
                               radius: 20.r,
                               disable: enable,
                             ),

                           ],
                         )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
