import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../code/constants_value.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../auth/login_screen.dart';
import 'EditUserInfo.dart';
import 'my_order_list.dart';
import 'orderUser.dart';
import 'order_employee_service.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  Position? currentPosition;
  List<Placemark>  placemarks = [];
  String myLocation = '';


  @override
  void initState() {
    _determinePosition();
    super.initState();
  }
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentHomecare]),
          ),
          drawer: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              var authCubit = AuthCubit.get(context);
              return (AuthCubit.get(context).userModel == null)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Drawer(
                      child: Column(
                      children: [
                        SizedBox(
                          height: 70.h,
                        ),
                        CircleAvatar(
                          radius: 80.r,
                          backgroundImage:
                              NetworkImage(authCubit.userModel!.photo),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xff1d1f32),
                                ),
                                Text(
                                  myLocation,
                                  style: TextStyle(color: Color(0xff1d1f32)),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),

                        ListTile(
                          leading: const Icon(Icons.settings),
                          iconColor: Color(0xff1d1f32),
                          title: const Text("Settings"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditUserInfo(),
                                ));
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          iconColor: Color(0xff1d1f32),
                          title: const Text("My order Service"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ShowOrderEmployeeService(),
                                ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          iconColor: Color(0xff1d1f32),
                          title: const Text("My order"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyOrder(),
                                ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.shopify),
                          iconColor: Color(0xff1d1f32),
                          title: const Text("Show all Orders"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyOrderList(),
                                ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          iconColor: Color(0xff1d1f32),
                          title: const Text("Call Support"),
                          onTap: () async {
                            final Uri call = Uri(
                              scheme: 'tel',
                              path: '+01121527620',
                            );
                            launchUrl(call);
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
                              'online': false,
                            }).then((value) async {
                              userID = null;
                              await CacheHelper.removeData(key: 'id');
                              await FirebaseAuth.instance.signOut();
                            }).then((value) {
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
                    ));
            },
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.handsWash), label: 'Cleaners'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.question_answer), label: 'Chat bot'),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.search), label: 'search'),
            ],
          ),
        );
      },
    );
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    currentPosition  = await Geolocator.getCurrentPosition();
    placemarks = await placemarkFromCoordinates(currentPosition!.latitude, currentPosition!.longitude);
    setState(() {
      myLocation = placemarks.reversed.last.subAdministrativeArea.toString();
    });

    print(placemarks.reversed.last.subAdministrativeArea.toString());
    return currentPosition!;
  }
}
