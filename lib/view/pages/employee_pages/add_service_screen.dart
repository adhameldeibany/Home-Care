import 'dart:io' as io;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../view_model/bloc/approve/approve_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}


TextEditingController titleController = TextEditingController();

TextEditingController descriptionController = TextEditingController();

TextEditingController costController = TextEditingController();

TextEditingController quantityController = TextEditingController();

bool showPassword = false;
final List<String> items = [
  'Emplyee',
  'Employees service',
];
String? selectedValue;
class _AddServiceScreenState extends State<AddServiceScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    titleController.text = '';
    descriptionController.text = '';
    costController.text = '';
    quantityController.text;
    ApproveCubit.get(context).image = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproveCubit, ApproveState>(
      listener: (context, state) {
        if(state is CreateServicesStateSuccessful){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('service Added Successfully'),
            ),
          );
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        var approveCubit = ApproveCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Service'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: (state is CreateServicesStateLoading),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              controller: titleController,
                              fieldValidator: (String ?value) {
                                if (value!.isEmpty) {
                                  return 'Title is required';
                                }
                              },
                              hint: 'Title',
                              iconData: Icons.title,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            CustomTextField(
                              textInputType: TextInputType.number,
                              controller: costController,
                              fieldValidator: (String?value) {
                                if (value!.isEmpty) {
                                  return "cost is required";
                                }
                              },
                              hint: 'Const',
                              iconData: Icons.price_change,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                            CustomButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  ApproveCubit.get(context).creteServices(
                                    title: titleController.text,
                                    cost: int.parse(costController.text),
                                  ).whenComplete(() {
                                    titleController.clear();
                                    costController.clear();
                                  });
                                }
                              },
                              widget: const Text("Post Service"),
                              size: Size(300.w, 50.h),
                              radius: 20.r,
                              disable: true,
                            ),
                          ],
                        ),
                      ),

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
