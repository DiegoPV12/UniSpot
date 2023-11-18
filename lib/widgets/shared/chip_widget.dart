import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String type;
  final bool isSelected;
  final VoidCallback onSelected;

  const ChipWidget({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        side: BorderSide.none,
        backgroundColor: Colors.grey[200],
        label: Text(type,
            style: const TextStyle(
              color: Color.fromARGB(255, 129, 40, 75),
            )),
        showCheckmark: false,
        selected: isSelected,
        selectedColor: const Color.fromARGB(255, 233, 201, 213),
        onSelected: (selected) => onSelected(),
 
      ),
    );
  }
}