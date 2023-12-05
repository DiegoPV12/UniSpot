import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider.builder(
              itemCount: space.imageUrl.length, // Se adapta al número de imágenes en la lista
              itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                // ignore: avoid_unnecessary_containers
                Container(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(150.0),
                    ),
                    child: Image.network(
                      space.imageUrl[itemIndex], // Muestra la imagen específica de la lista
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
              options: CarouselOptions(
                height: 500.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16/9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
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
                top: 20.0,
                left: 40.0,
                right: 40.0,
              ),
              child: SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReservationDetailsForm(space: space, reservation: null)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 129, 40, 75),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Reservar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
