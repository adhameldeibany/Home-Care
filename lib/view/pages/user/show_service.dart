import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view/components/custom_text_field.dart';
import 'package:graduation_project/view_model/bloc/product/employee_cubit.dart';
import '../../../code/resource/string_manager.dart';
import '../../../view_model/bloc/layout/layout__cubit.dart';

class ShowServiceHomecare extends StatefulWidget {
  const ShowServiceHomecare({Key? key}) : super(key: key);

  @override
  State<ShowServiceHomecare> createState() => _ShowServiceHomecareState();
}

class _ShowServiceHomecareState extends State<ShowServiceHomecare> {
  @override
  TextEditingController address = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    EmployeeCubit.get(context).getHomecareSpecificService(
        homecareID: LayoutCubit.get(context).EmplyeeModel!.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<EmployeeCubit, HomecareState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (state is GetServiceLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (EmployeeCubit.get(context).allservices.isEmpty)
                    ? const Center(
                        child: Text('No Service'),
                      )
                    : RefreshIndicator(
              onRefresh: () async {
              await  EmployeeCubit.get(context).getHomecareSpecificService(
                  homecareID: LayoutCubit.get(context).EmplyeeModel!.id.toString());
              },
                      child: ListView.builder(
                          itemCount:
                          EmployeeCubit.get(context).allservices.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      "Service Name : ${EmployeeCubit.get(context).allservices[index].title}"),
                                  subtitle: Text(
                                      "Cost : ${EmployeeCubit.get(context).allservices[index].cost.toString()}"),
                                  trailing: CustomButton(
                                    function: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Are you sure you want to Buy ${EmployeeCubit.get(context).allservices[index].title}"),
                                            content: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      "Cost : ${EmployeeCubit.get(context).allservices[index].cost.toString()}"),
                                                  CustomTextField(controller: address, hint: 'Enter Address', fieldValidator: (String ? value){
                                                    if(value!.isEmpty){
                                                      return "please enter your address";
                                                    }
                                                  })
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              CustomButton(
                                                function: ()
                                                {
                                                  if(formKey.currentState!.validate()){
                                                    EmployeeCubit.get(context).buyService(
                                                      cost: EmployeeCubit.get(context).allservices[index].cost,
                                                      title: EmployeeCubit.get(context).allservices[index].title,
                                                      address: address.text,
                                                      serviceID: EmployeeCubit.get(context).allservices[index].id.toString(),
                                                      homecareID: LayoutCubit.get(context).EmplyeeModel!.id.toString(),
                                                    ).then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                },
                                                widget: const Text("Yes"),
                                                radius: 10.r,
                                                disable: true,
                                                size: Size(100.w, 40.h),
                                              ),
                                              CustomButton(
                                                function: () {
                                                  Navigator.pop(context);
                                                },
                                                widget: const Text("No"),
                                                radius: 10.r,
                                                color: Colors.red,
                                                disable: true,
                                                size: Size(100.w, 40.h),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    widget: const Text(ADD_TO_CARD),
                                    radius: 10.r,
                                    disable: true,
                                    size: Size(100.w, 40.h),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    );
          },
        ));
  }
}
