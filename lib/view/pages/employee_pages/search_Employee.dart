import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:graduation_project/view_model/bloc/product/employee_cubit.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import '../../components/custom_button.dart';
import '../user/MedicineDetailsScreen.dart';
import 'Edit_Product_Screen.dart';

class SearchHomecare extends StatefulWidget {
  const SearchHomecare({Key? key}) : super(key: key);

  @override
  State<SearchHomecare> createState() => _SearchHomecareState();
}

class _SearchHomecareState extends State<SearchHomecare> {
  @override
  String name = '';
  List<ProductModel> productsModel = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            title: Text('Search Employee'),
          ),
            body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: darkorange),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: darkorange)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('product').where('homecareID',isEqualTo: CacheHelper.getDataString(key: 'id'))
                    .snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.w,
                                mainAxisSpacing: 15.h,
                                mainAxisExtent: 460.h,
                              ),
                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (context, index) {
                                productsModel = [];
                                for (var element in snapshots.data!.docs) {
                                  productsModel.add(
                                      ProductModel.fromMap(element.data() as Map<String, dynamic>));
                                }
                                if (name.isEmpty) {
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
                                                  productsModel[index]
                                                        .image),
                                                width: 200.w,
                                                height: 200.h),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            productsModel[index]
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
                                            "${productsModel[index].price.toString()} EGP ",
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
                                                              Text("Sure")),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                              Text("Cancel"))
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
                                                color: Colors.blueAccent,
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
                                                  Center(child: Text("Edit")),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                if (productsModel[index]
                                    .title
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(name.toLowerCase()))
                                {
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
                                                    productsModel[index]
                                                        .image),
                                                width: 200.w,
                                                height: 200.h),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            productsModel[index]
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
                                            "${productsModel[index].price.toString()} EGP ",
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
                                                              Text("Sure")),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                              Text("Cancel"))
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                widget: SizedBox(
                                                  height: 40.h,
                                                  width: 200,
                                                  child: Center(
                                                      child: Text("Delete")),
                                                ),
                                              ),
                                              CustomButton(
                                                disable: true,
                                                radius: 0,
                                                color: Colors.blueAccent,
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
                                                  Center(child: Text("Edit")),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        );
                },
              ),
            ],
          ),
        ));
      },
    );
  }
}
