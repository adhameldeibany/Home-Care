part of 'order_cubit.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}
class IncreaseState extends OrderState{}
class decrementState extends OrderState{}
class SuccessPriceState extends OrderState{}
class GetDataSuccessful extends OrderState{}

class GetTotalPriceState extends OrderState{}
class SendDataToDataBaseLoading extends OrderState{}
class SendDataToDataBaseSuccessful extends OrderState{}
class SendDataToDataBaseError extends OrderState{}
class RemoveDataLoading extends OrderState{}
class RemoveDataSuccessful extends OrderState{}
class RemoveDataError extends OrderState{}