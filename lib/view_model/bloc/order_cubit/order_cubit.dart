import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/order_model_data.dart';
import '../../../model/oreder_product_model.dart';
import '../../../model/product_model.dart';
import '../../database/local/cache_helper.dart';
import '../../database/local/sql_lite.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  static OrderCubit get(context) => BlocProvider.of<OrderCubit>(context);
  int? count;

  List<OrderModelData> orderList = [];

  Future<void> getOrderData() async {
    orderList = [];
    SQLHelper.getCard().then((value) {
      for (var element in value)  {
        orderList.add(OrderModelData.fromMap(element));
      }
    }).whenComplete(() {
      getRealData();
    });


  }
  num? total= 0;
  List<ProductModel>product = [];
  Future<void> getRealData() async {
    for (var element in orderList) {
       FirebaseFirestore.instance.collection("product").doc(element.idProduct).get().
      then((value) {

       product.add(ProductModel(
         imageHomecare:element.image ,
         quantity: element.quantity,
          id: element.idProduct,
          price: value.data()!['price'],
          image: value.data()!['image'],
         type: value.data()!['type'],
         title: value.data()!['title'],
         EmplyeeID:  value.data()!['homecareID'],
         description: value.data()!['description'],
         needPrescription: value.data()!['needPrescription'],
       ));
      }).then((value) {
         emit(SuccessPriceState());

       }).catchError((onError){
        print(onError);
      });
    }

  }
List<ProductPriceModel> productPriceModel = [];
  void CalculatePrice() {
    productPriceModel = [];
    orderList.forEach((element) {

    });
    emit(SuccessPriceState());
  }

  void increase(int count) {
    count = count + 1;
    print(count);
    emit(IncreaseState());
  }
  
  void decrement({required int count}) {
    count++;
    emit(decrementState());
  }
  Future<void> sendData(BuildContext context) async {
    emit(SendDataToDataBaseLoading());
    String? id;
    for (var element in product)  {
      await FirebaseFirestore.instance.collection('Orders').
      add({
        'userId': CacheHelper.getDataString(key: 'id'),
        'date': DateTime.now(),
        'orderStatus': 'pending',
        'HomecareId': element.EmplyeeID,
        'product': {
          'imageHomecare': element.imageHomecare,
          'id': element.id,
          'title': element.title,
          'price': element.price,
          'image': element.image,
          'type': element.type,
          'description': element.description,
          'needPrescription': element.needPrescription,
          'quantity': element.quantity,
        }
      }).then((value) async {
        await FirebaseFirestore.instance.collection('Orders')
            .doc(value.id)
            .update({
          'orderId': value.id,
        }).then((value) {
          emit(SendDataToDataBaseSuccessful());

        });
      }).catchError((onError) {
        print(onError);
        emit(SendDataToDataBaseError());
      });
    }
  }
  void RemoveData()async
  {
    emit(RemoveDataLoading());
    await SQLHelper.deleteTable(1).then((value) {
      emit(RemoveDataSuccessful());
    }).catchError((onError){
      print(onError);
      emit(RemoveDataError());
    });
  }
}
