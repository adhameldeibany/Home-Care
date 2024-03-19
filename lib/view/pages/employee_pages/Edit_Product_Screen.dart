import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/employee_pages/edit_product_photo.dart';
import 'package:graduation_project/view_model/bloc/approve/approve_cubit.dart';
import 'package:graduation_project/view_model/bloc/product/employee_cubit.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';

class EditProductScreen extends StatefulWidget {
  final int index;
  EmployeeCubit homecareCubit;

  EditProductScreen(
      {Key? key, required this.index, required this.homecareCubit})
      : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController quantityController = TextEditingController();
  TextEditingController description = TextEditingController();
  final List<String> items = [
    'Cleaning',
    'Laundry',
  ];
  String? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    titleController.text =
        EmployeeCubit.get(context).productsModel![widget.index].title;
    priceController.text = EmployeeCubit.get(context)
        .productsModel![widget.index]
        .price
        .toString();
    description.text =
        EmployeeCubit.get(context).productsModel![widget.index].description;
    quantityController.text = EmployeeCubit.get(context)
        .productsModel![widget.index]
        .quantity
        .toString();
    selectedValue =
        EmployeeCubit.get(context).productsModel![widget.index].type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproveCubit, ApproveState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var approveCubit = ApproveCubit.get(context);
        return BlocConsumer<EmployeeCubit, HomecareState>(
          listener: (context, state) {
            // TODO: implement listener
            if(state is UpdateProductSuccsseful){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:
              Text("Edit product Succsseful"),backgroundColor: Colors.green,));
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Product'),
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          size: Size(200, 59),
                          disable: true,
                          widget: const Text("Edit Image"),
                          function: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: widget.homecareCubit,
                                    child: EditImage(index: widget.index),
                                  ),
                                ));
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              Row(
                                children: [
                                  const Text("Type : "),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  // SizedBox(
                                  //   width: 300.w,
                                  //   child: DropdownButtonHideUnderline(
                                  //     child: DropdownButton2(
                                  //       hint: Text(
                                  //         'Select Item',
                                  //         style: TextStyle(
                                  //           fontSize: 14,
                                  //           color: Theme.of(context).hintColor,
                                  //         ),
                                  //       ),
                                  //       items: items
                                  //           .map((item) =>
                                  //               DropdownMenuItem<String>(
                                  //                 value: item,
                                  //                 child: Text(
                                  //                   item,
                                  //                   style: const TextStyle(
                                  //                     fontSize: 14,
                                  //                   ),
                                  //                 ),
                                  //               ))
                                  //           .toList(),
                                  //       value: selectedValue,
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           selectedValue = value as String;
                                  //         });
                                  //       },
                                  //       buttonHeight: 40,
                                  //       buttonWidth: 140,
                                  //       itemHeight: 40,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              CustomTextField(
                                controller: description,
                                fieldValidator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "cost is required";
                                  }
                                },
                                hint: 'Description',
                                iconData: Icons.description,
                                maxLine: 5,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              CustomTextField(
                                textInputType: TextInputType.number,
                                controller: priceController,
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
                                widget: Text("Confirm Edit"),
                                function: () async {
                                  if (formKey.currentState!.validate()) {
                                    EmployeeCubit.get(context).updateProduct(
                                      quantity:
                                          int.parse(quantityController.text),
                                      title: titleController.text,
                                      id: EmployeeCubit.get(context)
                                          .productsModel![widget.index]
                                          .id,
                                      type: selectedValue!,
                                      description: description.text,
                                      price: int.parse(priceController.text),
                                    );
                                  }
                                },
                                disable: true,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
