part of 'edit_cubit.dart';

@immutable
abstract class EditState {}

class EditInitial extends EditState {}
class IncreaseState extends EditState{}
class decrementState extends EditState{}
