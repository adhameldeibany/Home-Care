import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/product/employee_cubit.dart';
import '../../../code/constants_value.dart';
import '../../../code/resource/string_manager.dart';
import '../user/MedicineDetailsScreen.dart';
class AdminShowProduct extends StatefulWidget {
  const AdminShowProduct({Key? key}) : super(key: key);

  @override
  State<AdminShowProduct> createState() => _AdminShowProductState();

}

class _AdminShowProductState extends State<AdminShowProduct> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    EmployeeCubit.get(context).getByTypes(type: 'Emplyee',x: 2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, HomecareState>(
      buildWhen: (previous, current) {
        if (current is GetProductSuccsseful) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        var cubit = EmployeeCubit.get(context);
        return (state is GetProductSuccsseful)
            ? Scaffold(
          appBar: AppBar(
            title: Text('All Employees'),
          ),

              body: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await  EmployeeCubit.get(context).getByTypes(type: 'medicine',x: 2);
                  },
                  child:  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        mainAxisExtent: 300.h,
                      ),
                      shrinkWrap: true,
                      itemCount: cubit.getProductByType.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => MedicineDetailsScreen(
                            //           productModel:
                            //           cubit.getProductByType[index],
                            //         )));
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
                                  cubit.getProductByType[index].image,
                                  width: 80.w,
                                  height: 168.h,
                                ),
                                Text(cubit.getProductByType[index].title,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                    "EGP ${cubit.getProductByType[index].price}",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                // ElevatedButton.icon(
                                //     icon: Icon(Icons.shopping_cart),
                                //     onPressed: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   MedicineDetailsScreen(
                                //                     productModel: cubit
                                //                         .getProductByType[index],
                                //                   )));
                                //     },
                                //     label: const Text(ADD_TO_CARD),
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor:  buttonColor,
                                //     ))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
        ),
            )
            : const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
