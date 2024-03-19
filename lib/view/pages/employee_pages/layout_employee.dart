import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../code/constants_value.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../admin_screen/settings_screen.dart';
import '../auth/login_screen.dart';


class LayoutEmployee extends StatefulWidget {
  const LayoutEmployee({Key? key}) : super(key: key);

  @override
  State<LayoutEmployee> createState() => _LayoutEmployeeState();
}

class _LayoutEmployeeState extends State<LayoutEmployee> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return Scaffold(

          body:cubit.Homecare[cubit.currentHomecare],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentHomecare,
            type: BottomNavigationBarType.fixed,
            onTap: (index){
              cubit.changeBottomNavBarHomecare(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),

              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.search),
                  label: 'search',

              ),
            ],
          ),
        );
      },
    );
  }
}
