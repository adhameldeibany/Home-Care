import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({
    required this.controller,
    required this.hint,
    this.password = false,
    this.passwordTwo = false,
    this.function,
    required this.fieldValidator,
    this.iconData,
    this.textInputType = TextInputType.text,
    this.enable = true,
    this.maxLine = 1,
    this.formate,
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;
  final String hint;
  final bool password;
  final bool passwordTwo;
  final Function fieldValidator;
  final Function? function;
  final IconData ?iconData;
  final TextInputType textInputType;
  final bool enable;
  final int maxLine ;
   List<TextInputFormatter> ?formate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: formate,
      controller: controller,
      validator: (value) => fieldValidator(value),
      keyboardType : textInputType,
      enabled: enable,
      maxLines: maxLine,
      decoration: InputDecoration(
        icon: Icon(iconData),
          iconColor: darkorange,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkorange)),
          errorBorder:  UnderlineInputBorder(
              borderSide: BorderSide(color: ColorManage.redError)),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorManage.gray)),
          hintText: hint,
          suffix: (passwordTwo)
              ? GestureDetector(
            child: (password)
                ? const Icon(Icons.visibility_outlined)
                : const Icon(Icons.visibility_off),
            onTap: () {
              function!();
            },
          )
              : SizedBox()),
      obscureText: password,
    );
  }
}