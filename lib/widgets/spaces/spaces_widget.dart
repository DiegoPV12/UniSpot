import 'package:flutter/material.dart';
import '../../models/space_model.dart';
import '../../views/spaces/spaces_details_page.dart';

class SpaceCardWidget extends StatelessWidget {
  final SpaceModel space;
  final double imageWidth;
  final double imageHeight;
  final String uid; // Parámetro adicional para el UID

  const SpaceCardWidget({
    super.key,
    required this.space,
    this.imageWidth = 200.0,
    this.imageHeight = 200.0,
    required this.uid, // Incluir el UID en el constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpaceDetailsPage(space: space),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.network(
                space.imageUrl.isNotEmpty ? space.imageUrl[0] : 'assets/placeholder.jpg',
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/UnivalleLogo.png',
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.cover,
                  );
                },
              ),
              Container(
                width: imageWidth,
                color: const Color.fromARGB(255, 233, 201, 213),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      space.name,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 129, 40, 75),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text( // Mostrando el UID
                      uid,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(255, 129, 40, 75),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
