import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/model/homecare_model.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LayOutUserEmployee extends StatefulWidget {
  LayOutUserEmployee({Key? key, this.homecareModel}) : super(key: key);
  HomecareModel? homecareModel;

  @override
  State<LayOutUserEmployee> createState() => _LayOutUserEmployeeState();
}

class _LayOutUserEmployeeState extends State<LayOutUserEmployee> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      return Scaffold(

        body: LayoutCubit.get(context)
            .screenUserHomecare[LayoutCubit.get(context).currentHomecare],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            LayoutCubit.get(context).changeBottomNavBarHomecare(index);
          },
          currentIndex: LayoutCubit.get(context).currentHomecare,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.production_quantity_limits), label: 'Product'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_repair_service), label: 'Services'),
          ],
        ),
      );
    });
  }
}
