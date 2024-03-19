import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../view_model/bloc/auth/auth_cubit.dart';
class CustomerScreenAdmin extends StatefulWidget {
  const CustomerScreenAdmin({Key? key}) : super(key: key);

  @override
  State<CustomerScreenAdmin> createState() => _CustomerScreenAdminState();
}

class _CustomerScreenAdminState extends State<CustomerScreenAdmin> {
  @override
  void initState() {
    // TODO: implement initState

    AuthCubit.get(context).getAllCustomer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // print(userID.toString()+ "from sql");

        var authCubit = AuthCubit.get(context);
        return Scaffold(

          body: (state is GetAllCustomerScreenLoading)? Center(child: CircularProgressIndicator(),):SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: (AuthCubit.get(context).userModel == null)
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : (authCubit.getAllCustomerList.isEmpty)
                  ? const Center(
                child: Text("No Admin Found"),
              )
                  : Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          authCubit.getAllCustomer();
                        },
                        icon: const Icon(Icons.refresh),

                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: authCubit.getAllCustomerList.length,
                        itemBuilder: (context, index) {
                          if(!authCubit.getAllCustomerList[index].ban){
                            return Card(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(authCubit
                                        .getAllCustomerList[index].photo
                                        .toString()),
                                    radius: 40,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Name : ${authCubit.getAllCustomerList[index].name}"),
                                      Text(
                                          "Phone : ${authCubit.getAllCustomerList[index].phone}"),
                                      authCubit.getAllCustomerList[index].online
                                          ? Row(
                                        children: const [
                                          Text("Status : "),
                                          Text(
                                            "online",
                                            style: TextStyle(
                                                color: Colors.green),
                                          )
                                        ],
                                      )
                                          : Row(
                                        children: const [
                                          Text("Status : "),
                                          Text(
                                            "offline",
                                            style: TextStyle(
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text(
                                                "You want Delete Account ?"),
                                            content: Column(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: const [
                                                Text(
                                                    "If You click ok you will Ban this Account")
                                              ],
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      14),
                                                  child:
                                                  const Text("Cancel"),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(AuthCubit.get(
                                                      context)
                                                      .getAllCustomerList[index]
                                                      .id)
                                                      .update({
                                                    'ban': true
                                                  }).then((value) {

                                                    Navigator.of(ctx).pop();
                                                    AuthCubit.get(context).getAllCustomer();
                                                    setState(() {});
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      14),
                                                  child: const Text("Ok"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const FaIcon(FontAwesomeIcons.ban , color: Colors.red,)),
                                  IconButton(
                                      onPressed: ()
                                      {
                                        _launchInBrowser( Uri(scheme: 'https', host: 'wa.me', path: "+${authCubit
                                            .adminData[index].phone}"));

                                      },
                                      icon:  FaIcon(FontAwesomeIcons.phone ,))
                                ],
                              ),
                            );
                          }else{
                            return Card(
                              child: Stack(
                                children: [

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(authCubit
                                            .getAllCustomerList[index].photo
                                            .toString()),
                                        radius: 40,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Name : ${authCubit.getAllCustomerList[index].name}"),
                                          Text(
                                              "Phone : ${authCubit.getAllCustomerList[index].phone}"),
                                          authCubit.getAllCustomerList[index].online
                                              ? Row(
                                            children: const [
                                              Text("Status : "),
                                              Text(
                                                "online",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )
                                            ],
                                          )
                                              : Row(
                                            children: const [
                                              Text("Status : "),
                                              Text(
                                                "offline",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      // TextButton(
                                      //   onPressed: () {
                                      //     FirebaseFirestore.instance
                                      //         .collection('users')
                                      //         .doc(AuthCubit.get(
                                      //         context)
                                      //         .adminData[index]
                                      //         .id)
                                      //         .update({
                                      //       'ban': true
                                      //     }).then((value) {
                                      //
                                      //       Navigator.of(context).pop();
                                      //       AuthCubit.get(context).getAdmin();
                                      //       setState(() {});
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //     padding:
                                      //     const EdgeInsets.all(
                                      //         14),
                                      //     child: const Text("Ok"),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: ()
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text(
                                              "You want Remove Ban Account ?"),
                                          content: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: const [
                                              Text(
                                                  "If You click ok you will Remove Ban From this Account ? ")
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(
                                                    14),
                                                child:
                                                const Text("Cancel"),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(AuthCubit.get(
                                                    context)
                                                    .getAllCustomerList[index]
                                                    .id)
                                                    .update({
                                                  'ban': false
                                                }).then((value) {

                                                  Navigator.of(context).pop();
                                                  AuthCubit.get(context).getAllCustomer();

                                                });
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(
                                                    14),
                                                child: const Text("Ok"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 100.h,
                                      color: Colors.black.withOpacity(0.5),
                                      child: Center(
                                        child: Text(
                                          "Banned",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                        }),
                  ),
                ],
              )),
        );
      },
    );
  }
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
