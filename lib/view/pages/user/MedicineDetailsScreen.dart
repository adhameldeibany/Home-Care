import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';
import 'package:graduation_project/view_model/database/local/sql_lite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../code/constants_value.dart';
import '../../../code/resource/string_manager.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart' as auth;

class MedicineDetailsScreen extends StatefulWidget {
  MedicineDetailsScreen({Key? key, required this.productModel})
      : super(key: key);
  ProductModel productModel;

  @override
  State<MedicineDetailsScreen> createState() => _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  int count = 1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.productModel.title),
      ),
      body: BlocConsumer<UserCubit, UserState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return ModalProgressHUD(
        inAsyncCall: state is UploadImageStateLoading,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 200.h,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(widget.productModel.image),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  (widget.productModel.title),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "EGP : ${(widget.productModel.price.toString())}",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24.sp),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Description :",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24.sp),
                ),
                Text(
                  " ${(widget.productModel.description)}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, height: 1.5, fontSize: 20.sp),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 10,
                ),

                Text(
                  "Available Stoke : ${(widget.productModel.quantity.toString())}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 20.h,
                ),
                (auth.AuthCubit.get(context).userModel!.role!='1')?Row(
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                          onPressed: () {
                            if (count < widget.productModel.quantity) {
                              setState(() {
                                ++count;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Color(0xffF8F8F8),
                      child: Text("$count"),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                          onPressed: () {
                            if (count == 1) {

                            }
                            else {
                              setState(() {
                                --count;
                              });
                            }
                          },
                          icon: Text(
                            "-",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.sp),
                          )),
                    ),
                  ],
                ):SizedBox(),
                SizedBox(
                  height: 20.h,
                ),

                // Form(
                //   key: formKey,
                //   child: CustomTextField(controller: controller, hint: 'EnterAddress', fieldValidator: (String ? value){
                //     if(value!.isEmpty){
                //       return 'Enter Address';
                //     }
                //     return null;
                //
                //   },
                //   iconData: Icons.location_on_outlined,),
                // ),
                SizedBox(
                  height: 20.h,
                ),

                (auth.AuthCubit.get(context).userModel!.role!='1')?
                (widget.productModel.quantity <=0 )? const Text('Out of Stock' ,
                  style: TextStyle(
                  color: Colors.red,
                ),): BlocConsumer<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state is UploadImageSuccessfulState) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Adding to Card Successful'),
                      ));
                      Navigator.pop(context);
                    }
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return (state is BuyProductLoadingState)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            widget: const Text(ADD_TO_CARD),
                            color: buttonColor,
                            function: () {
                              if (widget.productModel.needPrescription) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    XFile? image;
                                    return BlocConsumer<UserCubit, UserState>(
                                      listener: (context, state) {
                                        // TODO: implement listener
                                      },
                                      builder: (context, state) {
                                        return ModalProgressHUD(
                                          inAsyncCall: state is UploadImageStateLoading,
                                          child: AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                    "Please Upload Your Prescription"),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                (UserCubit.get(context).image != null)
                                                    ? Image(
                                                        image: FileImage(
                                                            io.File(UserCubit.get(context).image!.path)),
                                                      )
                                                    : const Text("No Image Selected"),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                CustomButton(

                                                    disable: true,
                                                    size: Size(100.w, 50.h),

                                                    function: () async {
                                                      UserCubit.get(context).pickImageFromCamera();
                                                    },
                                                    widget:
                                                    const Center(child: Text("Camera"))),
                                                CustomButton(
                                                    size: Size(100.w, 50.h),
                                                  disable: true,
                                                    function: () async {
                                                      UserCubit.get(context).pickImageFromGallery();
                                                    },
                                                    widget:
                                                    const Text("Gallery")),
                                              ],
                                            ),
                                                CustomButton(
                                                    size: Size(100.w, 50.h),
                                                    disable: true,
                                                    function: () async {
                                                      if(UserCubit.get(context).image != null){
                                                        UserCubit.get(context).uploadFile(context,widget.productModel,count).whenComplete(() {
                                                        });
                                                      }else {
                                                      }
                                                      // UserCubit.get(context).pickImageFromGallery();

                                                    },
                                                    widget:
                                                    Text("Uplode")),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                SQLHelper.addCard(
                                        image: '',
                                        idProduct: widget.productModel.id,
                                        homecareID: widget.productModel.id,
                                        quantity: count
                                )
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Adding to Card Successful')));
                                  // debugPrint('Add Data in card Successful');

                                });
                              }

                              // if(formKey.currentState!.validate()){
                              //   UserCubit.get(context).buyProduct(
                              //       productModel: widget.productModel, quantity: count
                              //       ,address: controller.text,
                              //     title: widget.productModel.title
                              //   );
                              // }
                            },
                            disable: true,
                          );
                  },
                ):SizedBox()
              ],
            ),
          ),
        ),
      );
  },
),
    );
  }
}
