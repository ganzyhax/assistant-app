part of 'create_bloc.dart';

@immutable
sealed class CreateState {}

final class CreateInitial extends CreateState {}

final class CreateLoaded extends CreateState {
  List<double> location;
  CreateLoaded({required this.location});
}
