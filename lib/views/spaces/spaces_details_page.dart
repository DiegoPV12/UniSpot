import 'package:flutter/material.dart';
import '../../models/space_model.dart';
import '../reservation_form/reservation_form.dart';

class SpaceDetailsPage extends StatelessWidget {
  final SpaceModel space;

  const SpaceDetailsPage({
    Key? key,
    required this.space,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservando Espacio'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 500,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(150.0),
              ),
              child: Image.network(
                space.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/UnivalleLogo.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              space.name,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              space.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 80.0,
              left: 40.0,
              right: 40.0,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ReservationDetailsForm(space: space)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 129, 40, 75),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Reservar',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
