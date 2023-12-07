abstract class SpacesEvent {}

class LoadSpacesEvent extends SpacesEvent {}

class FilterByTypeEvent extends SpacesEvent {
  final String type;

  FilterByTypeEvent(this.type);
}
