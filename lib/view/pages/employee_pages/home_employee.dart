import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';
import 'package:graduation_project/view/pages/employee_pages/get_employee_services.dart';
import 'package:graduation_project/view/pages/employee_pages/show_all_service_order.dart';
import 'package:graduation_project/view/pages/employee_pages/show_orders.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/bloc/product/employee_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../view_model/database/local/cache_helper.dart';
import '../../components/custom_button.dart';
import '../auth/login_screen.dart';
import 'Edit_Product_Screen.dart';
import 'add_service_screen.dart';
import 'create_product.dart';
import 'edit_employee_info.dart';
import 'messageScreen.dart';

class HomeHomecareScreen extends StatefulWidget {
  const HomeHomecareScreen({Key? key}) : super(key: key);

  @override
  State<HomeHomecareScreen> createState() => _HomeHomecareScreenState();
}

class _HomeHomecareScreenState extends State<HomeHomecareScreen> {
  @override
  void initState() {
    // TODO: implement initState

    AuthCubit.get(context).getHomecareDetails();
    EmployeeCubit.get(context).getHomecareProduct();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Home Employee'),
              actions: [
                BlocConsumer<EmployeeCubit, HomecareState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return (state is GetProductLodaing)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : IconButton(
                            onPressed: () {
                              EmployeeCubit.get(context).getHomecareProduct();
                            },
                            icon: const Icon(Icons.refresh));
                  },
                )
              ],
            ),
            drawer: (AuthCubit.get(context).userModel == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Drawer(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100.h,
                          ),
                          CircleAvatar(
                            radius: 80.r,
                            backgroundImage:
                                NetworkImage(authCubit.userModel!.photo),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          ListTile(
                            leading: const Icon(Icons.perm_identity),
                            iconColor: Color(0xff1d1f32),
                            title: const Text("Create Product"),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const CreateProduct();
                                },
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
                                    builder: (context) =>
                                        const EditHomecareScreen(),
                                  ));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.home_repair_service),
                            iconColor: Color(0xff1d1f32),
                            title: const Text("service"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddServiceScreen(),
                                  ));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.design_services_sharp),
                            iconColor: Color(0xff1d1f32),
                            title: const Text("Show all Service"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const GetEmployeeServices(),
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
                                    builder: (context) => const ShowOrders(),
                                  ));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.chat),
                            iconColor: Color(0xff1d1f32),
                            title: const Text("messages"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MessageScreen(),
                                  ));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.medical_information),
                            iconColor: Color(0xff1d1f32),
                            title: const Text("Show All Order Service"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ShowAllServiceOrder(),
                                  ));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            iconColor: Color(0xff1d1f32),
                            title: const Text("Call Support"),
                            onTap: () async
                            {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'tel',
                                path: '+201121527620',

                              );

                              launchUrl(emailLaunchUri);
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
                                await CacheHelper.removeData(key: 'id');
                                FirebaseAuth.instance.signOut();
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
                      ),
                    ),
                  ),
            body: (AuthCubit.get(context).userModel == null)
                ? const Center(child: CircularProgressIndicator())
                : BlocConsumer<EmployeeCubit, HomecareState>(
                    buildWhen: (previous, current) {
                      if (current is GetProductSuccsseful) {
                        return true;
                      } else if (current is GetProductError) {
                        return true;
                      } else {
                        return false;
                      }
                    },
                    builder: (context, state) {
                      if (state is GetProductSuccsseful) {
                        if (EmployeeCubit.get(context).productsModel.isEmpty) {
                          return const Center(
                            child: Text("No Products"),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                                mainAxisExtent: 450.h,
                              ),
                              itemCount: EmployeeCubit.get(context)
                                  .productsModel
                                  .length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          child: Image(
                                              image: NetworkImage(
                                                  EmployeeCubit.get(context)
                                                      .productsModel[index]
                                                      .image),
                                              width: 200.w,
                                              height: 200.h),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          EmployeeCubit.get(context)
                                              .productsModel[index]
                                              .title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          "${EmployeeCubit.get(context).productsModel[index].price.toString()} EGP ",
                                          style: TextStyle(fontSize: 24.sp),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            CustomButton(
                                              disable: true,
                                              color: Colors.red,
                                              radius: 0,
                                              size: const Size(200, 20),
                                              function: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                          "Are You Sure To Delete This Product"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              EmployeeCubit.get(
                                                                      context)
                                                                  .deleteProduct(
                                                                      id: EmployeeCubit.get(
                                                                              context)
                                                                          .productsModel[
                                                                              index]
                                                                          .id)
                                                                  .then(
                                                                      (value) {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child:
                                                                const Text("Sure")),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                const Text("Cancel"))
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              widget: SizedBox(
                                                height: 40.h,
                                                width: 200,
                                                child: const Center(
                                                    child: Text("Delete")),
                                              ),
                                            ),
                                            CustomButton(
                                              disable: true,
                                              radius: 0,
                                              color: darkorange,
                                              size: const Size(200, 20),
                                              function: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return EditProductScreen(
                                                        index: index,
                                                        homecareCubit:
                                                        EmployeeCubit.get(
                                                                context));
                                                  },
                                                ));
                                              },
                                              widget: SizedBox(
                                                height: 40.h,
                                                width: 200.w,
                                                child:
                                                    const Center(child: Text("Edit")),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    listener: (context, state) {},
                  ));
      },
    );
  }
}
