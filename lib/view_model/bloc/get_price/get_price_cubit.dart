import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/model/product_model.dart';
import 'package:meta/meta.dart';

part 'get_price_state.dart';

class GetPriceCubit extends Cubit<GetPriceState> {
  GetPriceCubit() : super(GetPriceInitial());

  static GetPriceCubit get(context) => BlocProvider.of<GetPriceCubit>(context);
  num total = 0;

  void totalPrice(List<ProductModel> orderList) {
    total = 0;
    for (var element in orderList) {
      total = total + (element.price * element.quantity);
    }
    print(total);
    emit(SuccessPriceState());
  }
}
