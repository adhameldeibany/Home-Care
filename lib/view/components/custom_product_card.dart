import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomBuyCardProduct extends StatelessWidget {
  const CustomBuyCardProduct(
      {Key? key,
        required this.function,
        required this.title,
        required this.image,
        required this.price
      })
      : super(key: key);

  final Function function;
  final String image;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        width: 514.w,
        height: 540.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          children: [
            Image.network(
              image,
              width: 80.w,
              height: 168.h,
            ),
            Text(title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(
              height: 10.h,
            ),
            Text(" $price EGP",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            // ElevatedButton.icon(icon:Icon( Icons.shopping_cart),onPressed: (){
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               MedicineDetailsScreen(
            //                 productModel:
            //                 cubit.productModel[
            //                 index],
            //               )));
            // }, label: const Text(ADD_TO_CARD),style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff30CA00)),)
          ],
        ),
      ),
    );
  }
}
