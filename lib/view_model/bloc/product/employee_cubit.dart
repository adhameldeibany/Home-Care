import 'dart:io' as io;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/get_product_model.dart';
import '../../../model/get_service_model.dart';
import '../../../model/order_model.dart';
import '../../../model/product_model.dart';
import '../../../model/service_model.dart';
import '../../../model/user_info_model.dart';
import '../../../model/user_model.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<HomecareState> {
  EmployeeCubit() : super(HomecareInitial());

  static EmployeeCubit get(context) => BlocProvider.of<EmployeeCubit>(context);
  List<ProductModel> productsModel = [];

  Future<void> getHomecareProduct() async {
    emit(GetProductLodaing());
    productsModel = [];
    await FirebaseFirestore.instance
        .collection('product')
        .where('HomecareID', isEqualTo: CacheHelper.getDataString(key: 'id'))
        .get()
        .then((value) {
      print(value.docs.length);
      for (var element in value.docs) {
        productsModel.add(ProductModel.fromMap(element.data()));
      }
      print(productsModel.length);
      emit(GetProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetProductError('onError'));
    });
  }

  Future<void> updateProduct({
    required String description,
    required int price,
    required String title,
    required String type,
    required int quantity,
    required String id,
  }) async {
    emit(UpdateProductLodaing());
    await FirebaseFirestore.instance.collection('product').doc(id).update({
      'title': title,
      'price': price,
      'quantity': quantity,
      'description': description,
      'type': type,
    }).then((value) {
      productsModel = [];
      getHomecareProduct();
      emit(UpdateProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(UpdateProductError('onError'));
    });
  }

  Future<void> editImageProduct(
      XFile? file, BuildContext context, String docId) async {
    emit(UploadImageLoadingState());
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );

      return;
    }

    UploadTask uploadTask;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('/${file.name}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      print('Adham2');
      ref.putFile(io.File(file.path), metadata).then((p0) => {
            ref.getDownloadURL().then((value) async {
              await FirebaseFirestore.instance
                  .collection('product')
                  .doc(docId)
                  .update({'image': value}).then((value) {
                getHomecareProduct();
                emit(UploadImageSuccessfulState('done'));
              });

              // here modify the profile pic
            })
          });
    }
  }

  Future<void> deleteProduct({required String id}) async {
    emit(DeleteProductLoading());

    await FirebaseFirestore.instance
        .collection('product')
        .doc(id)
        .collection('orders')
        .get()
        .then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection('product')
            .doc(id)
            .collection('orders')
            .doc(element.id)
            .delete();
      }
    }).then((value) async {
      await FirebaseFirestore.instance.collection('product').doc(id).delete();
      getHomecareProduct();
      emit(DeleteProductSuccessful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(DeleteProductError('onError'));
    });
  }

  List<OrderModel> orders = [];
  List<ProductModel> productsOrder = [];
  List<GetServiceModel> services = [];
  List<GetProductModel> products = [];
  List<UserInfo> users = [];

  Future<void> getOrders(String status) async {
    emit(GetOrderLoading());
    products = [];
    await FirebaseFirestore.instance
        .collection('Orders')
        .where('HomecareId', isEqualTo: CacheHelper.getDataString(key: 'id'))
        .where('orderStatus', isEqualTo: status)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        products.add(GetProductModel.fromMap(element.data()));
        await FirebaseFirestore.instance.collection('users').
        doc(element.data()['userId']).get().then((value) {
          users.add(UserInfo.fromMap(value.data()!));
        });
      }
      emit(GetOrderSuccessful('Successful'));

    }).catchError((onError) {
      print(onError);
      emit(GetOrderError('Error'));
    });
  }

  Future<void> getOrdersService(String status) async {
    emit(GetOrderLoading());
    services = [];
    await FirebaseFirestore.instance
        .collection('services')
        .where('homecareID', isEqualTo: CacheHelper.getDataString(key: 'id'))
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await FirebaseFirestore.instance
            .collection('services')
            .doc(element.id)
            .collection('orders')
            .where('status', isEqualTo: status)
            .get()
            .then((value) {
          for (var element in value.docs) {
            services.add(GetServiceModel.fromMap(element.data()));
          }
          print(services.length);
        });
      }
      emit(GetOrderSuccessful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetOrderError('Error'));
    });
  }

  Future<void> rejectService(
      {required String orderID,
      required String productID,
      required int index}) async {
    emit(AcceptOrderLoading());
    await FirebaseFirestore.instance
        .collection('services')
        .doc(productID)
        .collection('orders')
        .doc(orderID)
        .update({
      'status': 'Reject',
    }).then((value) {
      getOrdersService('Pending');
    }).catchError((onError) {
      emit(AcceptOrderError('Error'));
    });
  }

  Future<void> acceptOrderService(
      {required String orderID,
      required String productID,
      required int index}) async {
    emit(AcceptOrderLoading());
    await FirebaseFirestore.instance
        .collection('services')
        .doc(productID)
        .collection('orders')
        .doc(orderID)
        .update({
      'status': 'Accepted',
    }).then((value) {
      getOrdersService('Pending');
    }).catchError((onError) {
      emit(AcceptOrderError('Error'));
    });
  }

  Future<void> acceptOrder(
      {required String orderID,
      required String productID,
        required int quantity,
        required BuildContext context,
      required int index}) async {

    emit(AcceptOrderLoading());
    await FirebaseFirestore.instance.collection('product').doc(productID).get().then((value) async{
      if(value.data()!['quantity']<=0)
      {
        showDialog(context: context, builder:
        (context) {
          return AlertDialog(
            title: Text('Sorry'),
            content: Text('This product is out of stock'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Ok'))
            ],
          );
        });
      }else{
        await FirebaseFirestore.instance
            .collection('product')
            .doc(productID)
            .update({
          'quantity': FieldValue.increment(-quantity),
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection('Orders')
              .doc(orderID)
              .update({
            'orderStatus': 'Accepted',
          }).then((value) {
            products.removeAt(index);
            emit(AcceptOrderSuccessful('Successful'));
          });
        }).catchError((onError) {
          emit(AcceptOrderError('Error'));
        });
      }
    });

  }

  Future<void> reject({required String orderID, required int index}) async {
    emit(AcceptOrderLoading());

    await FirebaseFirestore.instance.collection('Orders').
    doc(orderID).update({
      'orderStatus': 'Reject',
    }).then((value) {
      products.removeAt(index);
      emit(AcceptOrderSuccessful('Successful'));
    }).catchError((onError) {
      emit(AcceptOrderError('Error'));
    });
  }

  Future<void> getHomecareSpecificProduct({required String homecareID}) async {
    emit(GetProductLodaing());
    productsModel = [];
    await FirebaseFirestore.instance
        .collection('product')
        .where('homecareID', isEqualTo: homecareID)
        .get()
        .then((value) {
      print(value.docs.length);
      for (var element in value.docs)
      {
        productsModel.add(ProductModel.fromMap(element.data()));
      }
      print(productsModel.length);
      emit(GetProductSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetProductError('onError'));
    });
  }

  List<ServiceModel> allservices = [];

  Future<void> getHomecareSpecificService({required String homecareID}) async {
    allservices = [];
    emit(GetServiceLoading(''));

    await FirebaseFirestore.instance
        .collection('services')
        .where('homecareID', isEqualTo: homecareID)
        .get()
        .then((value) {
      print(value.docs.length);
      for (var element in value.docs) {
        allservices.add(ServiceModel.fromMap(element.data()));
      }
      print(allservices.length);
      emit(GetServiceSuccsseful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetServiceError('onError'));
    });
  }

  List<ProductModel> getProductByType = [];

  Future<void> getByTypes({required String type , int ?x}) async {
    emit(GetProductLodaing());
    getProductByType = [];
    if(x==null){
      await FirebaseFirestore.instance
          .collection('product')
          .where('type', isEqualTo: type)
          .get()
          .then((value) {
        print(value.docs.length);
        for (var element in value.docs) {
          getProductByType.add(ProductModel.fromMap(element.data()));
        }
        print(getProductByType.length);
        emit(GetProductSuccsseful('Successful'));
      }).catchError((onError) {
        print(onError);
        emit(GetProductError('onError'));
      });
    }else{
      await FirebaseFirestore.instance
          .collection('product')
          .get()
          .then((value) {
        print(value.docs.length);
        for (var element in value.docs) {
          getProductByType.add(ProductModel.fromMap(element.data()));
        }
        print(getProductByType.length);
        emit(GetProductSuccsseful('Successful'));
      }).catchError((onError) {
        print(onError);
        emit(GetProductError('onError'));
      });
    }

  }

  List<UserModel> usersMessage = [];

  Future<void> getMessage() async {
    emit(GetMessageLoading());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getDataString(key: 'id'))
        .collection('message')
        .get()
        .then((value) {
      emit(GetMessageSuccessful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetMessageError('Error'));
    });
  }

  Future<void> getUsers() async {
    emit(GetUsersMessageLoading());
    usersMessage = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '3')
        .get()
        .then((value) {
      for (var element in value.docs) {
        print(element.data());
        usersMessage.add(UserModel.fromMap(element.data()));
      }
      emit(GetUsersMessageSuccessful('Successful'));
    }).catchError((error) {
      print(error);
      emit(GetUsersMessageError('Error'));
    });
  }

  num currentRate = 0.0;
  num userRate = 0.0;

  Future<void> postRateToHomecare(
      {required String homecareId, required double rate}) async {
    emit(PostRateLoading());
    debugPrint('rate is $homecareId');
    if (userRate == 0) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(homecareId)
          .collection('rate')
          .add({
        'userID': CacheHelper.getDataString(key: 'id'),
        'rate': rate,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(homecareId)
            .collection('rate')
            .doc(value.id)
            .update({
          'id': value.id,
        }).then((value) {
          emit(PostRateSuccessful('Successful'));
        });
      }).catchError((onError) {
        print(onError);
        emit(PostRateError('Error'));
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(homecareId)
          .collection('rate')
          .where('userID', isEqualTo: CacheHelper.getDataString(key: 'id'))
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(homecareId)
              .collection('rate')
              .doc(element.id)
              .update({
            'rate': rate,
          }).then((value) {
            emit(PostRateSuccessful('Successful'));
          });
        });
      });
    }
  }

  Future<void> getRateHomecare({
    required String homecareId,
  }) async {
    emit(GetCurrentRateLoading('loading'));
    currentRate = 0.0;
    debugPrint('rate is $homecareId');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(homecareId)
        .collection('rate')
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        currentRate = 0.0;
      } else {
        for (var element in value.docs) {
          currentRate = currentRate + element.data()['rate'];
        }
        currentRate = currentRate / value.docs.length;
      }
      emit(GetCurrentRateSuccessful('loaing'));
    }).catchError((value) {
      emit(GetCurrentRateError('Error'));
    });
  }

  Future<void> getUserRate({
    required String homecareId,
  }) async {
    emit(GetUserRateLoading('loading'));
    userRate = 0.0;
    debugPrint('rate is $homecareId');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(homecareId)
        .collection('rate')
        .where('userID', isEqualTo: CacheHelper.getDataString(key: 'id'))
        .get()
        .then((value) {
      for (var element in value.docs) {
        userRate = element.data()['rate'];
      }
      print(userRate);
      emit(GetUserRateSuccessful('loaing'));
    }).catchError((value) {
      emit(GetUserRateError('Error'));
    });
  }

  Future<void> buyService(
      {required String serviceID,
      required String homecareID,
      required String address,
      required int cost,
      required String title}) async {
    emit(BuyServiceLoading(''));
    await FirebaseFirestore.instance
        .collection('services')
        .doc(serviceID)
        .collection('orders')
        .add({
      'userID': CacheHelper.getDataString(key: 'id'),
      'homecareID': homecareID,
      'serviceID': serviceID,
      'address': address,
      'status': 'pending',
      'title': title,
      "cost": cost,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('services')
          .doc(serviceID)
          .collection('orders')
          .doc(value.id)
          .update({
        'id': value.id,
      }).then((value) {
        emit(BuyServiceSuccessful('Successful'));
      });
    }).catchError((onError) {
      print(onError);
      emit(BuyServiceError('Error'));
    });
  }
}
