import 'dart:io' as io;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../view_model/bloc/approve/approve_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

TextEditingController titleController = TextEditingController();

TextEditingController descriptionController = TextEditingController();

TextEditingController costController = TextEditingController();

TextEditingController quantityController = TextEditingController();

final List<String> items = [
  'Cleaning',
  'Laundry',
];
final List<String> items2 = [
  'No',
  'Yes',
];
String? selectedValue;
String ? selectedValue2;

class _CreateProductState extends State<CreateProduct> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproveCubit, ApproveState>(
      listener: (context, state) {
        if (state is AddProductSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product Added Successfully'),
            ),
          );
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        var approveCubit = ApproveCubit.get(context);
        return ModalProgressHUD(
          inAsyncCall: approveCubit.wait,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create Product'),
            ),
            body: (state is UploadImageStateLoading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            (approveCubit.image == null)
                                ? const SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Center(
                                      child: Text('No Image Selected'),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Image.file(
                                        io.File(approveCubit.image!.path),
                                        height: 170,
                                        width: 170,
                                        fit: BoxFit.cover,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            approveCubit.removeImage();
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 40,
                                          )),
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButton(
                                  disable: true,
                                  size: Size(170.w, 40.h),
                                  widget: const Text("Select from gallery"),
                                  function: () {
                                    ApproveCubit.get(context)
                                        .pickImageGallary(context);
                                  },
                                ),
                                CustomButton(
                                  size: Size(170.w, 40.h),
                                  disable: true,
                                  widget: const Text("Select from camera"),
                                  function: () {
                                    ApproveCubit.get(context)
                                        .pickImageCamera(context);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Type : ", style: TextStyle(
                                        color: Color(0xffe25a3b), fontSize: 16, fontWeight: FontWeight.bold,
                                      ),),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SizedBox(
                                        width: 250.w,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            hint: Text(
                                              'Select Item',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            ),
                                            items: items
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
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Available : ", style: TextStyle(
                                        color: Color(0xffe25a3b), fontSize: 16, fontWeight: FontWeight.bold,
                                      ),),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SizedBox(
                                        width: 220.w,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            hint: Text(
                                              'Select Item',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                Theme.of(context).hintColor,
                                              ),
                                            ),
                                            items: items2
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
                                            value: selectedValue2,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedValue2 = value as String;
                                              });
                                            },
                                            buttonHeight: 40,
                                            buttonWidth: 140,
                                            itemHeight: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  CustomTextField(
                                    controller: titleController,
                                    fieldValidator: (String? value) {
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
                                    controller: descriptionController,
                                    fieldValidator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "cost is required";
                                      }
                                    },
                                    hint: 'Description',
                                    iconData: Icons.description,
                                    maxLine: 3,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  CustomTextField(
                                    textInputType: TextInputType.number,
                                    controller: costController,
                                    fieldValidator: (String? value) {
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
                                  CustomTextField(
                                    textInputType: TextInputType.number,
                                    controller: quantityController,
                                    fieldValidator: (String value) {
                                      if (value.isEmpty) {
                                        return "quantity is required";
                                      }
                                    },
                                    hint: 'quantity',
                                    iconData: Icons.production_quantity_limits,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),

                                  CustomButton(
                                    function: () {
                                      if (formKey.currentState!.validate() &&
                                          approveCubit.image != null &&
                                          selectedValue != null&&selectedValue2 != null) {
                                        ApproveCubit.get(context)
                                            .addProduct(
                                          needPrescription: (selectedValue2 == 'Yes')? true
                                              : false,
                                          title: titleController.text,
                                          description:
                                              descriptionController.text,
                                          price: int.parse(costController.text),
                                          quantity: int.parse(
                                              quantityController.text),
                                          context: context,
                                          type: selectedValue!,
                                        )
                                            .whenComplete(() async {
                                          quantityController.text = '';
                                          titleController.text = '';
                                          descriptionController.text = '';
                                          costController.text = '';

                                          ApproveCubit.get(context).image =
                                              null;
                                        }).whenComplete(() {});
                                      } else if (selectedValue == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please Select Type")));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please Select Image")));
                                      }
                                    },
                                    widget: Text("Post Product"),
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
