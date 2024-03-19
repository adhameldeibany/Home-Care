import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../view/pages/admin_screen/customer_screen.dart';
import '../../../view/pages/admin_screen/home_admin_screen.dart';
import '../../../view/pages/admin_screen/employee_screen_Admin.dart';

part 'layout_admin_state.dart';

class LayoutAdminCubit extends Cubit<LayoutAdminState> {
  LayoutAdminCubit() : super(LayoutAdminInitial());
  static LayoutAdminCubit get(context) =>
      BlocProvider.of<LayoutAdminCubit>(context);
  List<Widget> screens = [
    const AdminHomeScreen(),
    const EmployeeScreenAdmin(),
    const CustomerScreenAdmin()
  ];
  List<String> appbarTitle =
  [
    "Admins",
    "Employees",
    "Customer"
  ];
  int currentIndex = 0;
  void changeIndex(int index){
    currentIndex = index;
    emit(LayoutAdminChangeIndex());
  }
}
