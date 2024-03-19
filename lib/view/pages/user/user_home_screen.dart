import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';
import '../../components/custom_product_card.dart';
import 'MedicineDetailsScreen.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  @override
  void initState() {
    // TODO: implement initState
    UserCubit.get(context).getMedicine();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F3F7),
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return (AuthCubit.get(context).userModel == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return UserCubit.get(context).getMedicine();
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            BlocBuilder<UserCubit, UserState>(
                              buildWhen: (previous, current) {
                                if (current is GetMedicineSuccessfulState) {
                                  return true;
                                } else {
                                  return false;
                                }
                              },
                              builder: (context, state) {
                                var cubit = UserCubit.get(context);
                                return (state is GetMedicineSuccessfulState)
                                    ? (cubit.productModel.isEmpty)
                                        ? const Center(
                                            child: Text("No Product"),
                                          )
                                        : CarouselSlider.builder(
                                            options: CarouselOptions(
                                              height: 200.0,
                                              aspectRatio: 16 / 9,
                                              viewportFraction: 0.8,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  const Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: true,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                            itemCount:
                                                cubit.productModel.length,
                                            itemBuilder: (BuildContext context,
                                                    int itemIndex,
                                                    int pageViewIndex) =>
                                                InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MedicineDetailsScreen(
                                                              productModel: cubit
                                                                      .productModel[
                                                                  itemIndex],
                                                            )));
                                              },
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                    child: Image.network(
                                                      cubit
                                                          .productModel[
                                                              itemIndex]
                                                          .image,
                                                      fit: BoxFit.cover,
                                                      width: 1000.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                            // here the item of all product
                            BlocBuilder<UserCubit, UserState>(
                              buildWhen: (previous, current) {
                                if (current is GetMedicineSuccessfulState) {
                                  return true;
                                } else {
                                  return false;
                                }
                              },
                              builder: (context, state) {
                                var cubit = UserCubit.get(context);
                                return (cubit.productModel.isNotEmpty)
                                    ? SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 15.w,
                                                mainAxisSpacing: 15.h,
                                                    childAspectRatio: 2/3
                                              ),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  cubit.productModel.length,
                                              itemBuilder: (context, index) {
                                                return CustomBuyCardProduct(
                                                  function: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MedicineDetailsScreen(
                                                                  productModel:
                                                                      cubit.productModel[
                                                                          index],
                                                                )));
                                                  },
                                                  price: cubit
                                                      .productModel[index].price
                                                      .toString(),
                                                  title: cubit
                                                      .productModel[index]
                                                      .title,
                                                  image: cubit
                                                      .productModel[index]
                                                      .image,
                                                );
                                              }),
                                        ),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }),
    );
  }
}
