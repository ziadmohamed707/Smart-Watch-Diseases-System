import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

Widget CustomCard(String path, String name, String data, String? state) {
  return Card(
    elevation: 8.0,
    color: Color.fromARGB(30, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color.fromARGB(60, 255, 255, 255),
              child: Image.asset(
                path,
              ),
            ),
            SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomTextWidget(name, AppConstants.white, 18, FontWeight.bold),
                SizedBox(
                  height: 6,
                ),
                Text(
                  data,
                  style: TextStyle(
                      color: Color(0xFFFAFAFA),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
            Spacer(),
            Container(
              width: 61,
              height: 20,
              alignment: Alignment.center,
              color: Color(0xFF12A534),
              child: Text(
                'Normal',
                style: TextStyle(color: Color(0xFFFAFAFA), fontSize: 14),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
