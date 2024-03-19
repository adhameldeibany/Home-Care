part of 'approve_cubit.dart';

@immutable
abstract class ApproveState {}

class ApproveInitial extends ApproveState {}
class GetDataToApprovedStateSuccessful extends ApproveState{
  String message;
  GetDataToApprovedStateSuccessful(this.message);
}
class GetDataToApprovedStateSuccessfulEmpty extends ApproveState{
  String message;
  GetDataToApprovedStateSuccessfulEmpty(this.message);
}
class GetDataToApprovedStateError extends ApproveState{
  String message;
  GetDataToApprovedStateError(this.message);
}
class GetDataToApprovedStateLoading extends ApproveState{
  String message;
  GetDataToApprovedStateLoading(this.message);
}

class GetMoreInfoHomecareStateLoading extends ApproveState{

}
class GetMoreInfoHomecareStateSuccessful extends ApproveState{

}
class GetMoreInfoHomecareStateError extends ApproveState{}

class ApproveHomecareStateLoading extends ApproveState{}
class ApproveHomecareStateSuccessful extends ApproveState{}
class ApproveHomecareStateError extends ApproveState{}

class UploadImageStateLoading extends ApproveState{}
class UploadImageStateSuccessful extends ApproveState{}
class UploadError extends ApproveState{}

class pickImageGallaryStateSuccessful extends ApproveState{}
class pickImageCameraStateSuccessful extends ApproveState{}
class RemoveImageStateSuccessful extends ApproveState{}

class AddProductSuccessfulState extends ApproveState{
}
class AddProductStateLoading extends ApproveState{
}
class AddProductStateError extends ApproveState{
}
class CreateServicesStateLoading extends ApproveState{
  String message;
  CreateServicesStateLoading(this.message);
}
class CreateServicesStateError extends ApproveState{
  String message;
  CreateServicesStateError(this.message);
}
class CreateServicesStateSuccessful extends ApproveState{
  String message;
  CreateServicesStateSuccessful(this.message);
}