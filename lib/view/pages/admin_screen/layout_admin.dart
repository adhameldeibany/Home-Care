import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/admin_screen/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../../view_model/bloc/layout_admin/layout_admin_cubit.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../auth/login_screen.dart';
import 'admin_show_broduct.dart';
import 'approve_screen.dart';
import 'create_admin.dart';

class LayOutScreenAdmin extends StatefulWidget {
  const LayOutScreenAdmin({Key? key}) : super(key: key);

  @override
  State<LayOutScreenAdmin> createState() => _LayOutScreenAdminState();
}

class _LayOutScreenAdminState extends State<LayOutScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutAdminCubit, LayoutAdminState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title:  Text(LayoutAdminCubit.get(context).appbarTitle[LayoutAdminCubit.get(context).currentIndex]),
              centerTitle: true,

          ),
          drawer: (AuthCubit.get(context).userModel == null)
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Drawer(
            child: Column(
              children: [
                SizedBox(
                  height: 100.h,
                ),
                CircleAvatar(
                  radius: 80.r,
                  backgroundImage:
                  NetworkImage(AuthCubit.get(context).userModel!.photo),
                ),
                SizedBox(
                  height: 50.h,
                ),
                ListTile(
                  leading: const Icon(Icons.perm_identity),
                  iconColor: Color(0xff1d1f32),
                  title: const Text("Create Admin"),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const CreateAdmin();
                      },
                    ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  iconColor: Color(0xff1d1f32),
                  title: const Text("Approve Employee"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ApproveScreen(),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  iconColor: Color(0xff1d1f32),
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopify),
                  iconColor: Color(0xff1d1f32),
                  title: const Text("Orders"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminShowProduct(),
                        ));
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  iconColor: Color(0xff1d1f32),
                  title: const Text("Logout"),
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(CacheHelper.getDataString(key: 'id'))
                        .update({
                      'online': 'false',
                    }).then((value) async {
                      await FirebaseAuth.instance.signOut();
                    }).then((value) async {
                      await CacheHelper.removeData(key: 'id');
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                              (route) => false);
                    });
                  },
                ),
              ],
            ),
          ),
          body: LayoutAdminCubit.get(context).screens[LayoutAdminCubit.get(context).currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: LayoutAdminCubit.get(context).currentIndex,
          onTap: (index) {
            LayoutAdminCubit.get(context).changeIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Employee',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Customer',
            ),
          ],
        ),

        );
      },
    );
  }
}
