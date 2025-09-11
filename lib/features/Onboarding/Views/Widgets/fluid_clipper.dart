import 'package:flutter/material.dart';
import 'fluid_edge.dart';

class FluidClipper extends CustomClipper<Path> {
  FluidEdge edge;
  double margin;

  FluidClipper(this.edge, {this.margin = 0.0}) : super();

  @override
  Path getClip(Size size) {
    return edge.buildPath(size, margin: margin);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}