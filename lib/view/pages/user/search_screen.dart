import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';

import '../../../code/constants_value.dart';
import '../../../code/resource/string_manager.dart';
import 'MedicineDetailsScreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  String name = '';
  List<ProductModel> productModel = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
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
                  prefixIcon: Icon(Icons.search, color: darkorange,),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: darkorange)),
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
                    .collection('product')
                    .snapshots(),
                builder: (context, snapshots) {
                  return (
                          snapshots.connectionState ==
                          ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: ListView.builder(

                              itemCount: snapshots.data!.docs.length,
                              itemBuilder: (context, index) {
                                productModel = [];
                                snapshots.data!.docs.forEach((element) {
                                  productModel.add(ProductModel.fromMap(
                                      element.data() as Map<String, dynamic>));
                                });
                                if (name.isEmpty) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MedicineDetailsScreen(
                                                    productModel:
                                                        productModel[index],
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 200.w,
                                        height: 300.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15.r)),
                                        child: Column(
                                          children: [
                                            Image.network(
                                              productModel[index].image,
                                              width: 80.w,
                                              height: 168.h,
                                            ),
                                            Text(productModel[index].title,
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis),
                                            Text(
                                                "${productModel[index].price} EGP",
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis),
                                            ElevatedButton.icon(
                                              icon: Icon(Icons.shopping_cart),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MedicineDetailsScreen(
                                                              productModel:
                                                                  productModel[
                                                                      index],
                                                            )));
                                              },
                                              label: const Text(ADD_TO_CARD),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:buttonColor),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (productModel[index]
                                    .title
                                    .toString()
                                    .toLowerCase()
                                    .contains(name.toLowerCase())) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MedicineDetailsScreen(
                                                    productModel:
                                                        productModel[index],
                                                  )));
                                    },
                                    child: Container(
                                      width: 514.w,
                                      height: 540.h,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      child: Column(
                                        children: [
                                          Image.network(
                                            productModel[index].image,
                                            width: 80.w,
                                            height: 168.h,
                                          ),
                                          Text(productModel[index].title,
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          Text(
                                              "${productModel[index].price} EGP",
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          ElevatedButton.icon(
                                            icon: Icon(Icons.shopping_cart),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MedicineDetailsScreen(
                                                            productModel:
                                                                productModel[
                                                                    index],
                                                          )));
                                            },
                                            label: const Text(ADD_TO_CARD),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:Colors.red),
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
