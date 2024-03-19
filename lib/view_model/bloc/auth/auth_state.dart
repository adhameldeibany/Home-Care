part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
// login state start
class LoginLoadingState extends AuthState{
  LoginLoadingState();
}
class LoginSuccessfulState extends AuthState{
  String message;
  String role;
  bool ban;
  bool approved;
  LoginSuccessfulState({required this.message,required this.role , required this.ban,required this.approved});
}
class LoginErrorState extends AuthState{
  String message;
  LoginErrorState(this.message);
}
// login state end

// start Register state
class RegisterLoadingState extends AuthState{
  RegisterLoadingState();
}
class RegisterSuccessfulState extends AuthState{
  String message;
  RegisterSuccessfulState(this.message);
}
class RegisterErrorState extends AuthState{
  String message;
  RegisterErrorState(this.message);
}
// start Register state
// start Register state
class GetUserDataLoadingState extends AuthState{
  GetUserDataLoadingState();
}
class GetUserDataSuccessfulState extends AuthState{
  String message;
  GetUserDataSuccessfulState(this.message);
}
class GetUserDataErrorState extends AuthState{
  String message;
  GetUserDataErrorState(this.message);
}
// start Register state
// start Register state
class UpdateDataLoadingState extends AuthState{
  UpdateDataLoadingState();
}
class UpdateDataSuccessfulState extends AuthState{
  String message;
  UpdateDataSuccessfulState(this.message);
}
class UpdateDataErrorState extends AuthState{
  String message;
  UpdateDataErrorState(this.message);
}
// start Register state
//
class UploadImageStateSuccessful extends AuthState{
  String message;
  UploadImageStateSuccessful(this.message);
}
class UploadImageStateError extends AuthState{
  String message;
  UploadImageStateError(this.message);
}
class UploadImageStateLoading extends AuthState{
  String message;
  UploadImageStateLoading(this.message);
}
//end image state
// start get Admin
class GetAdminsStateSuccessful extends AuthState{
  String message;
  GetAdminsStateSuccessful(this.message);
}
class GetAdminsStateError extends AuthState{
  String message;
  GetAdminsStateError(this.message);
}
class GetAdminsStateLoading extends AuthState{
  String message;
  GetAdminsStateLoading(this.message);
}
// end admin
class SendMessageStateLoading extends AuthState{
  String message;
  SendMessageStateLoading(this.message);
}
class SendMessageStateError extends AuthState{
  String message;
  SendMessageStateError(this.message);
}
class SendMessageStateSuccessful extends AuthState{
  String message;
  SendMessageStateSuccessful(this.message);
}
// get Homecare details
class GetHomecareDetailsStateLoading extends AuthState{
  String message;
  GetHomecareDetailsStateLoading(this.message);
}
class GetHomecareDetailsStateError extends AuthState{
  String message;
  GetHomecareDetailsStateError(this.message);
}
class GetHomecareDetailsStateSuccessful extends AuthState{
  String message;
  GetHomecareDetailsStateSuccessful(this.message);
}
class AddHomecareDetailsStateLoading extends AuthState{
  String message;
  AddHomecareDetailsStateLoading(this.message);
}
class AddHomecareDetailsStateError extends AuthState{
  String message;
  AddHomecareDetailsStateError(this.message);
}
class AddHomecareDetailsStateSuccessful extends AuthState{
  String message;
  AddHomecareDetailsStateSuccessful(this.message);
}
// create services start
class GetUrlSuccessfulState extends AuthState{
  String message;
  GetUrlSuccessfulState(this.message);
}
// delete service end
class GetAllHomecareStateSuccessful extends AuthState{
  String message;
  GetAllHomecareStateSuccessful(this.message);
}
class GetAllHomecareStateError extends AuthState{
  String message;
  GetAllHomecareStateError(this.message);
}
class GetAllHomecareStateLoading extends AuthState{
  String message;
  GetAllHomecareStateLoading(this.message);
}
class GetAllCustomerScreenLoading extends AuthState{}
class GetAllCustomerScreenSuccessful extends AuthState{}
class GetAllCustomerScreenError extends AuthState{}