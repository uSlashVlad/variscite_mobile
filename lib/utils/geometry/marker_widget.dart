import 'package:flutter/material.dart';

import 'package:variscite_mobile/utils/geometry/geometry_styles.dart';

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({Key? key, required this.style}) : super(key: key);

  final MarkerStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: style.color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}