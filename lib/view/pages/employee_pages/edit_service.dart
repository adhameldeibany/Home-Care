import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/components/custom_button.dart';
import 'package:graduation_project/view/components/custom_text_field.dart';
import 'package:graduation_project/view_model/bloc/services/services_cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditService extends StatefulWidget {
  const EditService({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<EditService> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    priceController.text =
        ServicesCubit.get(context).serviceModel[widget.index].cost.toString();
    titleController.text =
        ServicesCubit.get(context).serviceModel[widget.index].title.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServicesCubit, ServicesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Service'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: state is EditSuccessfulLoading,
            child: Column(
                children: [
              CustomTextField(
                  controller: titleController,
                  hint: 'Title',
                  fieldValidator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter the cost';
                    }
                  }),
              CustomTextField(
                  controller: priceController,
                  hint: "cost",
                  fieldValidator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please enter the cost';
                    }
                  }),
              SizedBox(height: 20.h,),
                  CustomButton(disable: true,widget: const Text("Edit"), function: (){
                    ServicesCubit.get(context).editService(
                        title: titleController.text,
                        price: int.parse(priceController.text),
                        id: ServicesCubit.get(context).serviceModel[widget.index].id
                    ).then((value) {
                      Navigator.pop(context);
                    });

                  })
            ]),
          ),
        );
      },
    );
  }
}
