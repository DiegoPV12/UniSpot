import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/space_model.dart';
import '../../widgets/spaces/spaces_widget.dart';

class SpacesListPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  SpacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('spaces').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay espacios disponibles.'));
          }

          List<SpaceModel> spaces = snapshot.data!.docs
              .map((doc) => SpaceModel.fromDocument(doc))
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 55.0, bottom: 20.0),
                child: Text('Espacios Disponibles',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: 'Inter-ExtraBold')),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: spaces.length,
                  itemBuilder: (context, index) {
                    return SpaceCardWidget(space: spaces[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
