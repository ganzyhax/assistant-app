part of 'create_bloc.dart';

@immutable
sealed class CreateEvent {}

class CreateLoad extends CreateEvent {}

class CreateChooseLocation extends CreateEvent {
  List<double> location;
  CreateChooseLocation({required this.location});
}
