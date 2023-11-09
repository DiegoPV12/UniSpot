import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/space_service.dart';
import 'spaces_event.dart';
import 'spaces_state.dart';


class SpacesBloc extends Bloc<SpacesEvent, SpacesState> {
  final SpaceService spaceService;

  SpacesBloc({required this.spaceService}) : super(SpacesInitial()) {
    on<LoadSpacesEvent>(_onLoadSpaces);
    on<FilterByTypeEvent>(_onFilterByType);
  }

  Future<void> _onLoadSpaces(LoadSpacesEvent event, Emitter<SpacesState> emit) async {
    emit(SpacesLoading());
    try {
      var spaces = await spaceService.loadAllSpaces();
      emit(SpacesLoaded(spaces));
    } catch (e) {
      emit(SpacesError(e.toString()));
    }
  }

  Future<void> _onFilterByType(FilterByTypeEvent event, Emitter<SpacesState> emit) async {
    emit(SpacesLoading());
    try {
      var spaces = await spaceService.filterSpacesByType(event.type);
      emit(SpacesLoaded(spaces));
    } catch (e) {
      emit(SpacesError(e.toString()));
    }
  }
}
