import 'package:flutter/material.dart';

bool isHorizontal(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return width > height;
}
