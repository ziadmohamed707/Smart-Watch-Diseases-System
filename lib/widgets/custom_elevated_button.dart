import 'package:flutter/material.dart';

Widget CustomElevatedButton(context,text, foregroundColor, backgroundColor, onPress) {
  return Container(
    alignment: Alignment.center,
    width: double.infinity,
    child: SizedBox(
      height: 56,
      width: MediaQuery.of(context).size.width*0.9,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(foregroundColor),
          backgroundColor: Color(backgroundColor),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
            side: BorderSide(color: Colors.white, width: 1),
          ),
        ),
        child: Text(
          '$text',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
