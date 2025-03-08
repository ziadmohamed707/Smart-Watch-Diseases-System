import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

Widget CustomCard(String path, String name, String data, String? state,
    String? detailedState) {
  return state != 'Normal'
      ? Card(
          elevation: 8.0,
          color: const Color.fromARGB(30, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r), //  Responsive radius
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0.r), //  Responsive padding
            child: SizedBox(
              width: double.infinity,
              height: 80.h, //  Responsive height
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.r, //  Responsive radius
                    backgroundColor: const Color.fromARGB(60, 255, 255, 255),
                    child: Image.asset(
                      path,
                      width: 30.w, //  Responsive image size
                      height: 30.h,
                    ),
                  ),
                  SizedBox(width: 15.w), //  Responsive spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomTextWidget(name, AppConstants.white, 15.sp,
                          FontWeight.bold), //  Responsive text size
                      SizedBox(height: 6.h), //  Responsive spacing
                      Text(
                        data,
                        style: TextStyle(
                          color: const Color(0xFFFAFAFA),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp, //  Responsive text size
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 190.w,
                        height: 30.h,
                        child: state != 'Normal'
                            ? Card(
                                elevation: 8.0,
                                color: const Color.fromARGB(96, 170, 54, 145),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.r), //  Responsive radius
                                ), //  Responsive width
                                child: Center(
                                  child: data.contains('--') ||
                                          state == 'Critical'
                                      ? Text(
                                          'Details: $detailedState!',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize:
                                                10.sp, //  Responsive text size
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(''),
                                ),
                              )
                            : SizedBox(),
                      ), //  Responsive spacing
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 61.w, //  Responsive width
                    height: 20.h, //  Responsive height
                    alignment: Alignment.center,
                    color: state != 'Critical'
                        ? const Color(0xFF12A534)
                        : const Color.fromARGB(255, 255, 1, 1),
                    child: Text(
                      '$state',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 14.sp, //  Responsive text size
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      : Card(
          elevation: 8.0,
          color: const Color.fromARGB(30, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r), //  Responsive radius
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0.r), //  Responsive padding
            child: SizedBox(
              width: double.infinity,
              height: 60.h, //  Responsive height
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20.r, //  Responsive radius
                    backgroundColor: const Color.fromARGB(60, 255, 255, 255),
                    child: Image.asset(
                      path,
                      width: 30.w, //  Responsive image size
                      height: 30.h,
                    ),
                  ),
                  SizedBox(width: 15.w), //  Responsive spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      CustomTextWidget(name, AppConstants.white, 15.sp,
                          FontWeight.bold), //  Responsive text size
                      SizedBox(height: 6.h), //  Responsive spacing
                      Text(
                        data,
                        style: TextStyle(
                          color: const Color(0xFFFAFAFA),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp, //  Responsive text size
                        ),
                      ),
                      Spacer(),

                      //  Responsive spacing
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 61.w, //  Responsive width
                    height: 20.h, //  Responsive height
                    alignment: Alignment.center,
                    color: state != 'Critical'
                        ? const Color(0xFF12A534)
                        : const Color.fromARGB(255, 255, 1, 1),
                    child: Text(
                      '$state',
                      style: TextStyle(
                        color: const Color(0xFFFAFAFA),
                        fontSize: 14.sp, //  Responsive text size
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
}
