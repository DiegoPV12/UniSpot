import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/spaces/spaces_widget.dart';
import 'bloc/spaces_bloc.dart';
import 'bloc/spaces_event.dart';
import 'bloc/spaces_state.dart';


class SpacesListPage extends StatelessWidget {
  const SpacesListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aquí van los chips para filtrar
          SizedBox(
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
                  return ListView.builder(
                    itemCount: state.spaces.length,
                    itemBuilder: (context, index) {
                      return SpaceCardWidget(space: state.spaces[index]);
                    },
                  );
                }
                // Mostrar mensaje inicial o cualquier otro estado
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

class ChipWidget extends StatelessWidget {
  final String type;

  const ChipWidget({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(type),
        selected: false,
        onSelected: (selected) {
          // Aquí se despacha el evento para filtrar los espacios por tipo
          context.read<SpacesBloc>().add(FilterByTypeEvent(type));
        },
      ),
    );
  }
}
