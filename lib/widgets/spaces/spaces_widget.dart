import 'package:flutter/material.dart';
import '../../models/space_model.dart';

class SpaceCardWidget extends StatelessWidget {
  final SpaceModel space;
  final double imageWidth;
  final double imageHeight;

  const SpaceCardWidget({
    Key? key,
    required this.space,
    this.imageWidth = 300.0,
    this.imageHeight = 260.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize
          .min, // Para que la columna ocupe solo el espacio necesario
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(70.0),
            bottomLeft: Radius.circular(70.0),
          ),
          child: Image.network(
            space.imageUrl,
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 60.0, bottom: 20.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              space.name,
              style: const TextStyle(
                  color: Colors.black, 
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
