import 'package:graduation_project/model/product_model.dart';

class GetProductModel {
  String orderID;
  String ordeStatus;
  String image;
  String imageHomecare;
  int quantity;
  String title;
  String userID;
  int price;
  String type;
  String productID;

  GetProductModel({
    required this.orderID,
    required this.ordeStatus,
    required this.price,
    required this.image,
    required this.imageHomecare,
    required this.quantity,
    required this.title,
    required this.userID,
    required this.productID,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderID': this.orderID,
      'ordeStatus': this.ordeStatus,
      'image': this.image,
      'imageHomecare': this.imageHomecare,
      'quantity': this.quantity,
      'title': this.title,
      'userID': this.userID,
      'type': this.type,
    };
  }

  factory GetProductModel.fromMap(Map<String, dynamic> map) {
    return GetProductModel(
      orderID: map['orderId'] as String,
      ordeStatus: map['orderStatus'] as String,
      image: map['product']['image'] as String,
      price: map['product']['price'] as int,
      imageHomecare: map['product']['imageHomecare'] as String,
      quantity: map['product']['quantity'] as int,
      title: map['product']['title'] as String,
      userID: map['userId'] as String,
      productID: map['product']['id'] as String,
      type: map['product']['type'] as String,
    );
  }
}
