export 'chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../views/spaces/bloc/spaces_bloc.dart';
import '../../views/spaces/bloc/spaces_event.dart';

class ChipWidget extends StatelessWidget {
  final String type;

  const ChipWidget({super.key, required this.type});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        label: Text(type),
        selected: false,
        onSelected: (selected) {
          context.read<SpacesBloc>().add(FilterByTypeEvent(type));
        },
      ),
    );
  }
}



