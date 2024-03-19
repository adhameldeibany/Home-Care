import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view/pages/user/layout_employee_user.dart';
import 'package:graduation_project/view/pages/user/employee_product.dart';
import '../../../view_model/bloc/layout/layout__cubit.dart';
import '../../../view_model/bloc/user_cubit/user_cubit.dart';

class AllEmployeeScreen extends StatefulWidget {
  const AllEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AllEmployeeScreen> createState() => _AllEmployeeScreenState();
}

class _AllEmployeeScreenState extends State<AllEmployeeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    UserCubit.get(context).getHomecare();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) {
        if (current is GetHomecareSuccessfulState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return (state is GetHomecareSuccessfulState)
            ? SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await UserCubit.get(context).getHomecare();
                    },
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 15.h,
                          mainAxisExtent: 300.h,
                        ),
                        shrinkWrap: true,
                        itemCount: cubit.EmplyeeModel.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              LayoutCubit.get(context).x(cubit.EmplyeeModel[index]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LayOutUserEmployee(
                                            homecareModel:
                                                cubit.EmplyeeModel[index],
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
                                  SizedBox(height: 20,),
                                  Image.network(
                                    cubit.EmplyeeModel[index].photo,
                                    width: 80.w,
                                    height: 168.h,
                                  ),
                                  SizedBox(height: 20,),
                                  Text(cubit.EmplyeeModel[index].name,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 20,),
                                  Text(cubit.EmplyeeModel[index].address,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
