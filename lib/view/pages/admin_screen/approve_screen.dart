import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/approve/approve_cubit.dart';

class ApproveScreen extends StatefulWidget {
  const ApproveScreen({Key? key}) : super(key: key);

  @override
  State<ApproveScreen> createState() => _ApproveScreenState();
}

class _ApproveScreenState extends State<ApproveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      ApproveCubit.get(context).getDataToApproved();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApproveCubit, ApproveState>(listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      var size = MediaQuery.of(context).size;

      /*24 is for notification bar on Android*/
      final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
      final double itemWidth = size.width / 3;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Approve'),
        ),
        body: (state is GetDataToApprovedStateLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (ApproveCubit.get(context)
                    .detailsModelHomecareAdminApproved
                    .isNotEmpty)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 40.r,
                                backgroundImage: NetworkImage(
                                  ApproveCubit.get(context)
                                      .detailsModelHomecareAdminApproved[index]
                                      .photo
                                      .toString(),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ApproveCubit.get(context)
                                        .detailsModelHomecareAdminApproved[
                                            index]
                                        .name,
                                    style:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    ApproveCubit.get(context)
                                        .detailsModelHomecareAdminApproved[
                                            index]
                                        .email,
                                    style:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    ApproveCubit.get(context)
                                        .detailsModelHomecareAdminApproved[
                                            index]
                                        .address,
                                    style:  TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(

                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff30CA00),
                                          fixedSize: Size(80.w, 30.h)),
                                      onPressed: () {
                                        ApproveCubit.get(context).approveHomecare(
                                            userID: ApproveCubit.get(context)
                                                .detailsModelHomecareAdminApproved[
                                                    index]
                                                .id,
                                            index: index);
                                      },
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          fixedSize: Size(80.w, 30.h)),
                                      onPressed: () {
                                        ApproveCubit.get(context).rejectHomecare(
                                            userID: ApproveCubit.get(context)
                                                .detailsModelHomecareAdminApproved[
                                                    index]
                                                .id,
                                            index: index);
                                      },
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: ApproveCubit.get(context)
                        .detailsModelHomecareAdminApproved
                        .length,
                  )
                : const Center(
                    child: Text("No Employees to Approve"),
                  ),
      );
    });
  }
}
