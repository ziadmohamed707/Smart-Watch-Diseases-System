import 'package:flutter/material.dart';

Widget CustomTextWidget(text, color ,double size,weight) {
  return Text(text,
      style: TextStyle(
          color: Color(color), fontWeight: weight, fontSize: size));
}
