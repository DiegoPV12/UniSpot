import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unispot/widgets/spaces/skeleton_card.dart';
import '../../widgets/shared/chip_widget.dart';
import '../../widgets/spaces/spaces_widget.dart';
import 'bloc/spaces_bloc.dart';
import 'bloc/spaces_state.dart';

class SpacesListPage extends StatelessWidget {
  const SpacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/UnivalleLogo2.jpeg',
          fit: BoxFit.contain,
          height: 180,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, bottom: 15.0, left: 15.0, right: 15.0),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    ChipWidget(type: 'Exteriores'),
                    ChipWidget(type: 'Sala de Computo'),
                    ChipWidget(type: 'Auditorios'),
                  ],
                ),
              ),
            ),
            BlocBuilder<SpacesBloc, SpacesState>(
              builder: (context, state) {
                if (state is SpacesLoading) {
                  // Mostrar varias skeleton cards
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: 6, // Número de skeleton cards a mostrar
                    itemBuilder: (context, index) {
                      return const SpaceSkeletonCard();
                    },
                  );
                } else if (state is SpacesLoaded) {
                  // Mostrar los datos reales
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: state.spaces.length,
                    itemBuilder: (context, index) {
                      return SpaceCardWidget(space: state.spaces[index]);
                    },
                  );
                } else if (state is SpacesError) {
                  // Manejar estado de error
                  return Center(child: Text('Error: ${state.message}'));
                }
                // Estado inicial o predeterminado
                return const Center(
                    child: Text('Seleccione un tipo de espacio.'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
