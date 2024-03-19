import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:meta/meta.dart';

import '../../../model/service_model.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesInitial());

  static ServicesCubit get(context) => BlocProvider.of<ServicesCubit>(context);
  List<ServiceModel> serviceModel = [];

  Future<void> getServices() async {
    emit(GetServiceLoading());
    serviceModel = [];
    await FirebaseFirestore.instance
        .collection('services')
        .where('homecareID', isEqualTo: CacheHelper.getDataString(key: 'id'))
        .get()
        .then((value) {
      for (var element in value.docChanges) {
        serviceModel.add(ServiceModel.fromMap(element.doc.data()!));
      }
      emit(GetServiceSuccessful());
    }).catchError((onError) {
      print(onError);
      emit(GetServiceError());
    });
  }

  Future<void> deleteService({required String id}) async {
    await FirebaseFirestore.instance
        .collection('services')
        .doc(id)
        .collection('orders')
        .get().then((value) async{
      for (var element in value.docChanges) {
        await FirebaseFirestore.instance
            .collection('services')
            .doc(id)
            .collection('orders')
            .doc(element.doc.id)
            .delete();
      }
    }).whenComplete(() async {
     await FirebaseFirestore.instance
          .collection('services')
          .doc(id)
          .delete()
          .then((value) {
        getServices();
      });
    });
  }

  Future<void> editService(
      {required String title,
        required int price,
        required String id}) async {
    emit(EditSuccessfulLoading());

    await FirebaseFirestore.instance
        .collection('services')
        .doc(id)
        .update({'title': title, 'cost': price}).then((value) {
      getServices();
      emit(EditSuccessfulState());
    });
  }
}
