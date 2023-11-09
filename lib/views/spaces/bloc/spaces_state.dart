import '../../../models/space_model.dart';

abstract class SpacesState {}

class SpacesInitial extends SpacesState {}

class SpacesLoading extends SpacesState {}

class SpacesLoaded extends SpacesState {
  final List<SpaceModel> spaces;

  SpacesLoaded(this.spaces);
}

class SpacesError extends SpacesState {
  final String message;

  SpacesError(this.message);
}
