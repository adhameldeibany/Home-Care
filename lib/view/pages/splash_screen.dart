import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';
import 'package:graduation_project/view/pages/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 4),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
          (context)=>LoginScreen(),
      ), (route) => true);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffafcfd),
        body: FadeIn(
          duration: Duration(seconds: 4),
          // delay: Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150.h,),
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 100.h,),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Developed by',
                    style: TextStyle(color: darkorange, fontSize: 17.sp, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 70, top: 5, left: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Adham Eldeibany',
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
