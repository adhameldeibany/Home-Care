import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit() : super(EditInitial());
  static EditCubit get(context)=>BlocProvider.of<EditCubit>(context);
  void increase(int count)
  {
    count =  count+1;
    print(count);
    emit(IncreaseState());
  }
  void decrement({required int count})
  {
    count++;
    emit(decrementState());
  }
}
