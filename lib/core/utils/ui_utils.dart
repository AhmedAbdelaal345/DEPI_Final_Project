import 'package:flutter/material.dart';
import 'package:depi_final_project/core/utils/ui_utils.dart';

// Utility scaling for 390 x 844 design (iPhone 13/14)
double sx(BuildContext context, double x) =>
    x * MediaQuery.of(context).size.width / 390;

double sy(BuildContext context, double y) =>
    y * MediaQuery.of(context).size.height / 844;
