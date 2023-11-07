import 'package:unispot/models/space_model.dart';
import 'package:unispot/services/space_service.dart';

void createDummySpaces() {
  var dummySpaces = [
    SpaceModel(
      uid: 'T-001',
      name: 'Sala de Computo',
      capacity: 50,
      description: 'Amplia sala con proyector y aire acondicionado.',
      imageUrl: 'assets/UnivalleLogo.png',
      availableTimeSlots: ['9:00 - 11:00', '11:00 - 13:00'],
    ),
  ];

  for (var space in dummySpaces) {
    SpaceService.instance.saveSpaceToFirestore(space).catchError((e) {
      print('Error al guardar espacio dummy: $e');
    });
  }
}
