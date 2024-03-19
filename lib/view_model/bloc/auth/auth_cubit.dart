import 'dart:io' as io;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/model/homecare_model.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../model/details_model.dart';
import '../../../model/product_model.dart';
import '../../../model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);
  UserModel? userModel;
  final ImagePicker _picker = ImagePicker();

  // login function start
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    userModel = null; // here i remove all old data to receive New Data
    await FirebaseAuth
        .instance // firebase auth this library i use it to login i send request Email and password
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      // if login successful i will update user is online to true
      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .update({'online': true});
      await CacheHelper.put(
          key: 'id', value: value.user!.uid); // i cache user id to use
      // if login successful i will get user id and i will use it to get user data from firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .get()
          .then((value) async {
        // here i will store user data in userModel
        userModel = UserModel.fromMap(value.data()!);
        await CacheHelper.put(
            key: 'role', value: userModel!.role); //  cashing role user
        emit(LoginSuccessfulState(
            role: value['role'],
            message: 'login success',
            ban: value['ban'],
            approved: value['approved']));
      });
    }).catchError((onError) {
      // if email Error or password Error show message :D
      if (onError is FirebaseAuthException) {
        emit(LoginErrorState(onError.message!));
      }
    });
  }

  Future<void> register(
      {required String email,
      required String password,
      required String phone,
      required String age,
      required String name,
      required String role,
      required String gender}) async {
    // register function start
    emit(RegisterLoadingState());
    await FirebaseAuth
        .instance // firebase auth this library i use it to register i send request Email and password
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      // if register successful i will add user data to firebase
      userModel = UserModel(
          address: '',
          description: '',
          chornic: [],
          gender: gender,
          phone: phone,
          age: age,
          ban: false,
          email: email,
          id: value.user!.uid,
          online: false,
          photo:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH6PjyUR8U-UgBWkOzFe38qcO29regN43tlGGk4sRd&s',
          approved: (role == '2') ? false : true,
          role: role,
          name: name);
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set(userModel!.toMap())
          .then((value) async {
        emit(RegisterSuccessfulState('Register success'));
      });
    }).catchError((onError) {
      if (onError is FirebaseAuthException) {
        print(onError.message);
        emit(RegisterErrorState(onError.message!));
      }
    });
  }

  Future<void> registerUser({
    required String gender,
    required String email,
    required String password,
    required String phone,
    required String age,
    required String name,
    required String role,
    required String address,
    required List<String> chornic,
  }) async {
    // register function start
    emit(RegisterLoadingState());
    print(password);
    await FirebaseAuth
        .instance // firebase auth this library i use it to register i send request Email and password
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      // if register successful i will add user data to firebase
      userModel = UserModel(
        chornic: chornic,
        description: '',
        address: address,
        phone: phone,
        age: age,
        ban: false,
        email: email,
        id: value.user!.uid,
        online: false,
        photo:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH6PjyUR8U-UgBWkOzFe38qcO29regN43tlGGk4sRd&s',
        approved: (role == '2') ? false : true,
        role: role,
        name: name,
        gender: gender,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set(userModel!.toMap())
          .then((value) async {});

      emit(RegisterSuccessfulState('Register success'));
    }).catchError((onError) {
      if (onError is FirebaseAuthException) {
        emit(RegisterErrorState(onError.message!));
      }
    });
  }

  HomecareModel? homecareModel;

  Future<void> registerEmploy({
    required String email,
    required String password,
    required String phone,
    required String name,
    required String role,
    required String description,
    required String address,
  }) async {
    // register function start

    emit(RegisterLoadingState());

    await FirebaseAuth
        .instance // firebase auth this library i use it to register i send request Email and password
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      print(password);
      // if register successful i will add user data to firebase
      userModel = UserModel(
        description: description,
        chornic: [],
        phone: phone,
        age: '',
        ban: false,
        email: email,
        id: value.user!.uid,
        online: false,
        photo:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH6PjyUR8U-UgBWkOzFe38qcO29regN43tlGGk4sRd&s',
        approved: (role == '2') ? false : true,
        role: role,
        name: name,
        gender: '',
        address: '',
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set(userModel!.toMap())
          .then((value) async {
        emit(RegisterSuccessfulState('Register success'));
      });
      emit(RegisterSuccessfulState('Register success'));
    }).catchError((onError) {
      if (onError is FirebaseAuthException) {
        emit(RegisterErrorState(onError.message!));
      }
    });
  }

  Future<void> getUserData() async {
    userModel = null;
    emit(GetUserDataLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data()!);

      emit(GetUserDataSuccessfulState('data come true'));
    }).catchError((onError) {
      print(onError.toString());
      emit(GetUserDataErrorState('some Thing Error'));
    });
  }

  Future<void> update(
      {required String email,
      required String phone,
      required String age,
      required String name,
      required String address,
      required String description}) async {
    emit(UpdateDataLoadingState());
    print(userID);
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getDataString(key: 'id'))
        .update({
      'name': name,
      'phone': phone,
      'age': age,
      'email': email,
      'address': address,
      'description': description,
    }).then((value) {
      emit(UpdateDataSuccessfulState('done'));
    }).catchError((onError) {
      emit(UpdateDataErrorState('some thing Error'));
    });
  }

  Future<void> uploadFile(XFile? file, BuildContext context) async {
    emit(UploadImageStateLoading('loading'));
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
      ref.putFile(io.File(file.path), metadata).then((p0) => {
            ref.getDownloadURL().then((value) async {
              // here modify the profile pic
              userModel!.photo = value;
              print(value);
              print("{//////////////////");
              print(CacheHelper.getDataString(key: 'id'));
              print("{//////////////////");

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(CacheHelper.getDataString(key: 'id'))
                  .update({'photo': value}).then((value) {
                emit(UploadImageStateSuccessful('upload done'));
              }).catchError((onError) {
                emit(UploadImageStateError('Error'));
              });
            })
          });
    }
  }

  Future<void> pickImageGallary(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
    } else {
      await uploadFile(image, context).then((value) {});
    }
  }

  Future<void> pickImageCamera(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) {
    } else {
      await uploadFile(image, context).then((value) {});
    }
  }

  List<UserModel> adminData = [];

  Future<void> getAdmin() async {
    emit(GetAdminsStateLoading('loading'));
    adminData = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where(
          'role',
          isEqualTo: '1',
        )
        .get()
        .then((value) {
      print(value.docs.length);
      value.docChanges.forEach((element) {
        if (element.doc.data()!['id'] == CacheHelper.getDataString(key: 'id')) {
          print('same');
        } else {
          adminData.add(UserModel.fromMap(element.doc.data()!));
        }
      });
      emit(GetAdminsStateSuccessful('loading'));
    }).catchError((onError) {
      print(onError.toString());
      print('Adham');
      emit(GetAdminsStateError('loading'));
    });
  }

  String? docOne;
  String? docTwo;
  // send message firebase
  Future<void> sendMessage(
      {required String message,
      required String homecareID,
      required String customerName,
      required String customerId,
      required String homecareName,
      required String senderID,
      required String type,
      String? baseName}) async {
    emit(SendMessageStateLoading('loading'));
    print(baseName);
    FirebaseFirestore.instance
        .collection('users')
        .doc(customerId)
        .collection('messages')
        .add({
      'message': message,
      'senderID': senderID,
      'customerName': customerName,
      'homecareID': homecareID,
      'homecareName': homecareName,
      'customerId': customerId,
      'type': type,
      'time': DateTime.now().toString(),
      'baseName': baseName
    }).then((value) {
      docOne = value.id;
      FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .collection('messages')
          .doc(value.id)
          .update({
        'id': value.id,
      });
    }).catchError((onError) {
      emit(SendMessageStateError('onError'));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(homecareID)
        .collection('messages')
        .add({
      'message': message,
      'customerName': customerName,
      'senderID': senderID,
      'baseName': baseName,
      'homecareID': homecareID,
      'homecareName': homecareName,
      'customerId': customerId,
      'type': type,
      'time': DateTime.now().toString(),
    }).then((value) {
      docTwo = value.id;
      FirebaseFirestore.instance
          .collection('users')
          .doc(homecareID)
          .collection('messages')
          .doc(value.id)
          .update({
        'id': value.id,
        'docOne': docOne,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(customerId)
            .collection('messages')
            .doc(docOne)
            .update({
          'docOne': docTwo,
        });
      });
      print(value);
      emit(SendMessageStateSuccessful('Successful'));
    }).catchError((onError) {
      emit(SendMessageStateError('onError'));
    });
  }

  FilePickerResult? result;

  Future<void> pickFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      io.File file = io.File(result!.files.single.path.toString());
      FirebaseStorage.instance.ref().child('files').putFile(file).then((p0) {
        p0.ref.getDownloadURL().then((value) {
          print(value);
        });
      });
    }
  }

  String? baseName;

  Future<void> pickFileMessage(
      {required String customerId,
      required String homecareID,
      required String homecareName,
      required String customerName,
      required String type}) async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      io.File file = io.File(result!.files.single.path.toString());
      baseName = basename(file.path);

      FirebaseStorage.instance
          .ref()
          .child(result!.files.single.path.toString())
          .putFile(file)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          sendMessage(
              senderID: CacheHelper.getDataString(key: 'id').toString(),
              homecareName: homecareName,
              customerId: customerId,
              customerName: customerName,
              message: value,
              homecareID: homecareID,
              type: type,
              baseName: baseName);
        });
      });
    }
  }

  DetailsModelHomecare? detailsModelHomecare;

  Future<void> getHomecareDetails() async {
    emit(GetHomecareDetailsStateLoading('loading'));
    detailsModelHomecare = null;
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getDataString(key: 'id'))
        .collection('details')
        .get()
        .then((value) {
      for (var element in value.docs) {
        detailsModelHomecare = DetailsModelHomecare.fromMap(element.data());
      }

      emit(GetHomecareDetailsStateSuccessful('Successful'));
    }).catchError((onError) {
      print(onError);
      emit(GetHomecareDetailsStateError('onError'));
    });
  }

  Future<void> addHomecareDetails({
    required String dis,
    required String address,
  }) async {
    // emit(AddHomecareDetailsStateLoading('loading'));
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getDataString(key: 'id'))
        .collection('details')
        .add({
      'dis': dis,
      'address': address,
      'approved': false,
      'id': CacheHelper.getDataString(key: 'id'),
    }).then((value) async {
      await getHomecareDetails();
      emit(AddHomecareDetailsStateSuccessful('Successful'));
    }).catchError((onError) {
      emit(AddHomecareDetailsStateError('onError'));
    });
  }

  List<ProductModel> productsModel = [];
  List<HomecareModel> getAllHomecareList = [];
  List<UserModel> getAllCustomerList = [];

  Future<void> getAllHomecare() async {
    emit(GetAllHomecareStateLoading('loading'));
    getAllHomecareList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '2')
        .where('approved', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docChanges) {
        getAllHomecareList.add(HomecareModel.fromMap(element.doc.data()!));
      }
      print(getAllHomecareList.length);
      emit(GetAllHomecareStateSuccessful('Successful'));
    }).catchError((onError) {
      emit(GetAllHomecareStateError('onError'));
    });
  }

  Future<void> getAllCustomer() async {
    emit(GetAllCustomerScreenLoading());
    getAllCustomerList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: '3')
        .get()
        .then((value) {
      value.docChanges.forEach((element) {
        getAllCustomerList.add(UserModel.fromMap(element.doc.data()!));
      });
      emit(GetAllCustomerScreenSuccessful());
    }).catchError((onError) {
      emit(GetAllCustomerScreenError());
    });
  }
}
