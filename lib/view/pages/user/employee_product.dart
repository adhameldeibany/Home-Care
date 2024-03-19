import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/product/employee_cubit.dart';
import '../../../code/constants_value.dart';
import '../../../code/resource/string_manager.dart';
import 'MedicineDetailsScreen.dart';
import 'chat_screen.dart';

class EmployeeProduct extends StatefulWidget {
  EmployeeProduct({Key? key,}) : super(key: key);

  @override
  State<EmployeeProduct> createState() => _EmployeeProductState();
}

class _EmployeeProductState extends State<EmployeeProduct> {
  @override
  void initState() {
    // TODO: implement initState
    EmployeeCubit.get(context).getHomecareSpecificProduct(
        homecareID: LayoutCubit.get(context).EmplyeeModel!.id.toString()
    );
    super.initState();
  }

  double? rating;

  @override
 Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, HomecareState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = EmployeeCubit.get(context);
        print(cubit.productsModel.length);
        return Scaffold(
          backgroundColor: Color(0xffF2F3F7),
          appBar: AppBar(
            title: Text(LayoutCubit.get(context).EmplyeeModel!.name),
            actions: [
              (AuthCubit.get(context).userModel!.role !='1')?IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatUserScreen(
                          homecareModel: LayoutCubit.get(context).EmplyeeModel,
                        );
                      },
                    ));
                  },
                  icon: Icon(
                    Icons.chat,
                    color: Colors.white,
                  )):SizedBox(),
              (AuthCubit.get(context).userModel!.role !='1')?IconButton(
                  onPressed: () {
                    cubit
                        .getRateHomecare(
                            homecareId: LayoutCubit.get(context).EmplyeeModel!.id.toString())
                        .then((value) {
                      cubit
                          .getUserRate(homecareId: LayoutCubit.get(context).EmplyeeModel!.id)
                          .then((value) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text("Current Rate : ${cubit.currentRate}"),
                                  ],
                                ),
                                Text("User Rate : ${cubit.userRate}"),
                                SizedBox(
                                  height: 10.h,
                                ),
                                RatingBar.builder(
                                  initialRating: cubit.userRate.toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      this.rating = rating;
                                    });
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    EmployeeCubit.get(context)
                                        .postRateToHomecare(
                                            homecareId:
                                                LayoutCubit.get(context).EmplyeeModel!.id,
                                            rate: rating!)
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text("confirm")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("cancel")),
                            ],
                          ),
                        );
                      });
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color: Colors.white,
                  )) :SizedBox(),
              IconButton(
                  onPressed: () {
                 showDialog(context: context, builder: (context) {
                   return AlertDialog(
                     title:  Text("Description" , style: TextStyle(color: Colors.black , fontSize: 30.sp , fontWeight: FontWeight.bold),),
                     content: SingleChildScrollView(

                       child: Column(
                         children: [

                           Text(LayoutCubit.get(context).EmplyeeModel!.description)
                         ],
                       ),
                     ),
                   );
                 },);
                  },
                  icon: const Icon(
                    Icons.info,
                    color: Colors.white,
                  )),
            ],
          ),
          body: (state is GetProductLodaing)
              ? const Center(
                  child: Text('Emplyee Service'),
                )
              : SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        EmployeeCubit.get(context).getHomecareSpecificProduct(
                            homecareID: LayoutCubit.get(context).EmplyeeModel!.id.toString());
                      },
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15.w,
                            mainAxisSpacing: 15.h,
                            mainAxisExtent: 300.h,
                          ),
                          itemCount: cubit.productsModel.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MedicineDetailsScreen(
                                              productModel:
                                                  cubit.productsModel[index],
                                            )));
                              },
                              child: Container(
                                width: 514.w,
                                height: 540.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.r)),
                                child: Column(
                                  children: [
                                    Image.network(
                                      cubit.productsModel[index].image,
                                      width: 80.w,
                                      height: 168.h,
                                    ),
                                    Text(cubit.productsModel[index].title,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    Text(
                                        "${cubit.productsModel[index].price} EGP",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    (AuthCubit.get(context).userModel!.role !='1')?ElevatedButton.icon(
                                      icon: Icon(Icons.shopping_cart),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MedicineDetailsScreen(
                                                      productModel: cubit
                                                          .productsModel[index],
                                                    )));
                                      },
                                      label: const Text(ADD_TO_CARD),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                               buttonColor),
                                    ):SizedBox()
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
