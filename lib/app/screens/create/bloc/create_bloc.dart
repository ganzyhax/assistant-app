import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(CreateInitial()) {
    List<double> location = [];

    on<CreateEvent>((event, emit) {
      if (event is CreateLoad) {
        emit(CreateLoaded(location: location));
      }
      if (event is CreateChooseLocation) {
        location = event.location;
        emit(CreateLoaded(location: location));
      }
    });
  }
}
