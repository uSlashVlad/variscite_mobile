import 'package:flutter/material.dart';

@immutable
class MarkerStyle {
  MarkerStyle({Color? color}) {
    this.color = color ?? Colors.grey;
  }

  late final Color color;
}

@immutable
class LineStyle {
  LineStyle({Color? color, double? width, double? opacity}) {
    strokeColor = color ?? Colors.grey;
    strokeWidth = width ?? 4;
    strokeOpacity = opacity ?? 1;
  }

  late final Color strokeColor;
  late final double strokeWidth;
  late final double strokeOpacity;
}

@immutable
class PolygonStyle {
  PolygonStyle({
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    double? strokeOpacity,
    double? fillOpacity,
  }) {
    this.strokeColor = strokeColor ?? Colors.black;
    this.fillColor = fillColor ?? Colors.grey;
    this.strokeWidth = strokeWidth ?? 4;
    this.strokeOpacity = strokeOpacity ?? 1;
    this.fillOpacity = fillOpacity ?? 1;
  }

  late final Color strokeColor;
  late final Color fillColor;
  late final double strokeWidth;
  late final double strokeOpacity;
  late final double fillOpacity;
}
