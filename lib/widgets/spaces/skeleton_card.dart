import 'package:flutter/material.dart';

class SpaceSkeletonCard extends StatelessWidget {
  const SpaceSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100.0,
            color: Colors.grey[300],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Colors.grey[300]),
                const SizedBox(height: 5.0),
                Container(width: 150.0, height: 10.0, color: Colors.grey[300]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
