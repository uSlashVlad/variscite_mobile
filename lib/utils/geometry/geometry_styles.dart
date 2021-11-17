import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
class MarkerStyle extends Equatable {
  MarkerStyle({Color? color, Color? outlineColor}) {
    this.color = color ?? Colors.grey;
    this.outlineColor = outlineColor ?? Colors.white;
  }

  late final Color outlineColor;
  late final Color color;

  @override
  List<Object?> get props => [color, outlineColor];
}

@immutable
class LineStyle extends Equatable {
  LineStyle({Color? color, double? width, double? opacity}) {
    strokeColor = color ?? Colors.grey;
    strokeWidth = width ?? 4;
    strokeOpacity = opacity ?? 1;
  }

  late final Color strokeColor;
  late final double strokeWidth;
  late final double strokeOpacity;

  @override
  List<Object?> get props => [strokeColor, strokeWidth, strokeOpacity];
}

@immutable
class PolygonStyle extends Equatable {
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

  @override
  List<Object?> get props => [
        strokeColor,
        fillColor,
        strokeWidth,
        strokeOpacity,
        fillOpacity,
      ];
}
