part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}
// getMedicine state start
class GetMedicineLoadingState extends UserState {}
class GetMedicineSuccessfulState extends UserState {}
class GetMedicineErrorState extends UserState {
  final String error;
  GetMedicineErrorState(this.error);
}
// getMedicine state end
// getHomecare state start
class GetHomecareLoadingState extends UserState {}
class GetHomecareSuccessfulState extends UserState {}
class GetHomecareErrorState extends UserState {
  final String error;
  GetHomecareErrorState(this.error);
}
// getHomecare state end
class BuyProductLoadingState extends UserState {}
class BuyProductSuccessfulState extends UserState {}
class BuyProductErrorState extends UserState {
  final String error;
  BuyProductErrorState(this.error);
}
// get My Product state start
class GetMyProductLoadingState extends UserState {}
class GetMyProductSuccessfulState extends UserState {}
class GetMyProductErrorState extends UserState {
  final String error;
  GetMyProductErrorState(this.error);
}
// get My Product state end
class PickImageLoadingState extends UserState {}
class PickImageSuccessfulState extends UserState {}
class PickImageErrorState extends UserState {
  final String error;
  PickImageErrorState(this.error);
}
class UploadImageStateLoading extends UserState {}
class UploadImageSuccessfulState extends UserState {}
class UploadImageErrorState extends UserState {
  final String error;
  UploadImageErrorState(this.error);
}

