import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:flutter/material.dart';
var userID = CacheHelper.getDataString(key: 'id');
var role = CacheHelper.getDataString(key: 'role');

const Color buttonColor =  Color(0xff1d1f32);