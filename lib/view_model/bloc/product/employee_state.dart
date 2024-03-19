part of 'employee_cubit.dart';

@immutable
abstract class HomecareState {}

class HomecareInitial extends HomecareState {}
class GetProductLodaing extends HomecareState {}
class GetProductSuccsseful extends HomecareState {
  final String message;
  GetProductSuccsseful(this.message);
}
class GetProductError extends HomecareState {
  final String message;
  GetProductError(this.message);
}
// update state start
class UpdateProductLodaing extends HomecareState {}
class UpdateProductSuccsseful extends HomecareState {
  final String message;
  UpdateProductSuccsseful(this.message);
}
class UpdateProductError extends HomecareState {
  final String message;
  UpdateProductError(this.message);
}
class UploadImageLoadingState extends HomecareState {}
class UploadImageSuccessfulState extends HomecareState {
  final String message;
  UploadImageSuccessfulState(this.message);
}
class UploadImageErrorState extends HomecareState {
  final String message;
  UploadImageErrorState(this.message);
}
// update state end

// delete state start
class DeleteProductLoading extends HomecareState {}
class DeleteProductSuccessful extends HomecareState {
  final String message;
  DeleteProductSuccessful(this.message);
}
class DeleteProductError extends HomecareState {
  final String message;
  DeleteProductError(this.message);
}
// delete state end

// get product
class GetOrderLoading extends HomecareState {}
class GetOrderSuccessful extends HomecareState {
  final String message;
  GetOrderSuccessful(this.message);
}
class GetOrderError extends HomecareState {
  final String message;
  GetOrderError(this.message);
}
// delete product
class AcceptOrderLoading extends HomecareState {}
class AcceptOrderSuccessful extends HomecareState {
  final String message;
  AcceptOrderSuccessful(this.message);
}
class AcceptOrderError extends HomecareState {
  final String message;
  AcceptOrderError(this.message);
}
// delete product
class GetMessageLoading extends HomecareState {}
class GetMessageSuccessful extends HomecareState {
  final String message;
  GetMessageSuccessful(this.message);
}
class GetMessageError extends HomecareState {
  final String message;
  GetMessageError(this.message);
}
// delete product
class GetUsersMessageLoading extends HomecareState {}
class GetUsersMessageSuccessful extends HomecareState {
  final String message;
  GetUsersMessageSuccessful(this.message);
}
class GetUsersMessageError extends HomecareState {
  final String message;
  GetUsersMessageError(this.message);
}
// delete product
class PostRateLoading  extends HomecareState {

}
class PostRateSuccessful extends HomecareState {
  final String message;
  PostRateSuccessful(this.message);
}
class PostRateError extends HomecareState {
  final String message;
  PostRateError(this.message);
}
class GetCurrentRateLoading extends HomecareState {
  final String message;
  GetCurrentRateLoading(this.message);
}
class GetCurrentRateSuccessful extends HomecareState {
  final String message;
  GetCurrentRateSuccessful(this.message);
}
class GetCurrentRateError extends HomecareState {
  final String message;
  GetCurrentRateError(this.message);
}

class GetUserRateLoading extends HomecareState {
  final String message;
  GetUserRateLoading(this.message);
}
class GetUserRateSuccessful extends HomecareState {
  final String message;
  GetUserRateSuccessful(this.message);
}
class GetUserRateError extends HomecareState {
  final String message;
  GetUserRateError(this.message);
}
class GetServiceSuccsseful extends HomecareState {
  final String message;
  GetServiceSuccsseful(this.message);
}
class GetServiceLoading extends HomecareState {
  final String message;
  GetServiceLoading(this.message);
}
class GetServiceError extends HomecareState {
  final String message;
  GetServiceError(this.message);
}

class BuyServiceSuccessful extends HomecareState {
  final String message;
  BuyServiceSuccessful(this.message);
}
class BuyServiceError extends HomecareState {
  final String message;
  BuyServiceError(this.message);
}
class BuyServiceLoading extends HomecareState {
  final String message;
  BuyServiceLoading(this.message);
}