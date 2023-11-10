import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
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
          Expanded(
            child: BlocBuilder<SpacesBloc, SpacesState>(
              builder: (context, state) {
                if (state is SpacesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SpacesError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                if (state is SpacesLoaded) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing:
                          5.0, 
                      mainAxisSpacing:
                          4.0, 
                    ),
                    itemCount: state.spaces.length,
                    itemBuilder: (context, index) {
                      return SpaceCardWidget(space: state.spaces[index]);
                    },
                  );
                }
                return const Center(
                    child: Text('Seleccione un tipo de espacio.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
