import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_screen_state.dart';

class SearchScreenCubit extends Cubit<SearchScreenState> {
  SearchScreenCubit() : super(SearchScreenInitial());

  static SearchScreenCubit get(context) =>
      BlocProvider.of<SearchScreenCubit>(context);

  Future<void> searchProduct(String search) async {
   await FirebaseFirestore.instance
        .collection('product')
        .where('title', isEqualTo: search)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
      });
    });
    print('Adham');
  }
}
