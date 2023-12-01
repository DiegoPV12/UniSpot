import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unispot/widgets/shared/navbar.dart';
import 'package:unispot/widgets/spaces/skeleton_card.dart';
import '../../widgets/shared/chip_widget.dart';
import '../../widgets/spaces/spaces_widget.dart';
import 'bloc/spaces_bloc.dart';
import 'bloc/spaces_event.dart';
import 'bloc/spaces_state.dart';
import 'admin_page.dart';

class SpacesListPage extends StatefulWidget {
  const SpacesListPage({super.key});

  @override
  State<SpacesListPage> createState() => _SpacesListPageState();
}

class _SpacesListPageState extends State<SpacesListPage> {
  String _selectedType = '';

  void _handleChipSelected(String type) {
    setState(() {
      _selectedType = type;
    });
    context.read<SpacesBloc>().add(FilterByTypeEvent(type));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // Obtiene el usuario actual

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(129, 40, 75, 1),
        centerTitle: true,
        title: Image.asset(
          'assets/UnivalleNav.png',
          fit: BoxFit.contain,
          height: 80,
          color: Colors.white,
        ),
        actions: <Widget>[
          // Validación para mostrar el botón solo si el usuario es el administrador
          if (user != null && user.email == 'tbp6000372@est.univalle.edu')
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AdminPage(), // Navega a AdminPage
                ));
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 0,
        navigationContext: context,
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
                  children: [
                    ChipWidget(
                      type: 'Exteriores',
                      isSelected: _selectedType == 'Exteriores',
                      onSelected: () => _handleChipSelected('Exteriores'),
                    ),
                    ChipWidget(
                      type: 'Sala de Computo',
                      isSelected: _selectedType == 'Sala de Computo',
                      onSelected: () => _handleChipSelected('Sala de Computo'),
                    ),
                    ChipWidget(
                      type: 'Auditorios',
                      isSelected: _selectedType == 'Auditorios',
                      onSelected: () => _handleChipSelected('Auditorios'),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<SpacesBloc, SpacesState>(
              builder: (context, state) {
                if (state is SpacesLoading) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return const SpaceSkeletonCard();
                    },
                  );
                } else if (state is SpacesLoaded) {
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
                  return Center(child: Text('Error: ${state.message}'));
                }
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
