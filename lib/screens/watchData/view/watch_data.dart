import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/main.dart';
import 'package:iot_monitoring_chronic_diseases_system/provider/connected_dev_prov.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/discoverWatches/widget/base_layout.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/generalInformation/model/profile.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/watchData/model/healthStorage.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/watchData/model/watchDetails.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_app_bar_spacer.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_card.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class WatchDataScreen extends ConsumerStatefulWidget {
  const WatchDataScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WatchDataScreenState();
}

class _WatchDataScreenState extends ConsumerState<WatchDataScreen> {
  // used classes
  final AuthRepository _authRepository =
      AuthRepository(); // used for fetching api data
  late Profile profile = Profile(); // used for fetching profile data
  late Watchdetails watchDetails =
      Watchdetails(); // used for fetching watch data

  // used variables
  Timer? _locationTimer; // used for fetching location data
  Position? _currentPosition; // used for fetching position
  String? _locationError; // used for fetching location error

  // variables used for fetching sensor data
  List<BluetoothCharacteristic> sensorCharacteristics =
      []; // used for adding sensor characteristic
  Map<String, String> healthStatus = {}; // used for adding healthStatus
  late Map<String, dynamic> healthData = {}; // used for adding healthData

  // used variables for fetching location data
  late String _street = '';
  late String _country = '';

  // used variables for fetching image data
  File? _image;
  String? _imageUrl = "";

  // used variables for fetching name
  final TextEditingController _nameController = TextEditingController();

  // used variables for fetching decoded data
  String? BLOODPRESSURE = '';
  int? SYSTOLICBP = 0;
  int? DIASTOLICBP = 0;
  int? HEARTRATE = 0;
  int? SPO2 = 0;
  double? TEMPERATURE = 0;
  int? ECG = 0;

  // used variables for fetching status
  String? bloodPressureStatus = 'Normal';
  String? temperatureStatus = 'Normal';
  String? ecgStatus = 'Normal';
  String? spo2Status = 'Normal';
  String? heartRateStatus = 'Normal';

  Future<void> _showNotification(String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
      'channel_id',
      'Health Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, generalNotificationDetails);
  }

  Future<void> _saveChanges(String key, value) async {
    try {
      String? token = TokenStorage.getToken();
      final watchData = {
        key: value,
        "recorded_at": DateTime.now().toIso8601String(),
      };
      await _authRepository.sendWatchData(token!, watchData);
      print('Watch Data upladed successfully.');
    } catch (e) {
      print('Error uploaded Watch Data: $e');
    }
  }

  Future<void> _fetchProfileData() async {
    try {
      String? token = TokenStorage.getToken();
      final jsonData = await _authRepository.fetchProfile(token!);

      setState(() {
        profile = Profile.fromJson(jsonData);
        _nameController.text = profile.name ?? 'username';
        _imageUrl = (profile.image != null && profile.image!.isNotEmpty)
            ? profile.image
            : null; // Ensure `_imageUrl` is never an empty string
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  final Map<BluetoothCharacteristic, StreamSubscription<List<int>>>
      _sensorSubscriptions = {};

  @override
  initState() {
    super.initState();
    _readAndSubscribeCharacteristics();
    _startLocationUpdates();
    requestPermissions();
    _fetchProfileData();
    _getData();
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    _sensorSubscriptions.forEach((_, subscription) => subscription.cancel());
    _sensorSubscriptions.clear();

    // Unsubscribe from all sensor characteristics
    for (var characteristic in sensorCharacteristics) {
      if (characteristic.properties.notify) {
        characteristic.setNotifyValue(false);
      }
    }

    super.dispose();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        setState(() {
          _street = place.street ?? "Unknown Street";
          _country = place.subAdministrativeArea ?? "Unknown County";
        });

        debugPrint("Street: $_street, County: $_country");
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationError = "Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationError =
            "Location permissions are permanently denied, go to settings to enable them.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      // Get Address Details
      await _getAddressFromLatLng(position);

      setState(() {
        _currentPosition = position;
        _locationError = null;
      });

      debugPrint(
          "Location Updated: Lat: ${position.latitude}, Lng: ${position.longitude}");
    } catch (e) {
      setState(() => _locationError = "Error getting location: $e");
    }
  }

  /// Function to start fetching location every 10 minutes
  void _startLocationUpdates() {
    _locationTimer?.cancel(); // Cancel any existing timer to avoid duplicates

    _getLocation(); // Get location immediately when the app starts

    _locationTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      _getLocation();
    });
  }

  Future<void> _getData() async {
    healthData = await HealthStorage.loadHealthData();
  }

  Future<void> _readAndSubscribeCharacteristics() async {
    final connectedDev = ref.read(connectedDevProvProvider);

    if (connectedDev == null) {
      debugPrint('No connected device found.');
      return;
    }

    try {
      var services = await connectedDev.device.discoverServices();
      int i = 1;
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (service.uuid.toString().toLowerCase() ==
                  '00006287-3c17-d293-8e48-14fe2e4da212' ||
              service.uuid.toString().toLowerCase() == '1801' ||
              characteristic.uuid.toString().toLowerCase() == '3802' ||
              service.uuid.toString().toLowerCase() == '1800' ||
              characteristic.properties.notify) {
            sensorCharacteristics.add(characteristic);
            // await onSubscribe(characteristic);
            await characteristic.setNotifyValue(true);

            _sensorSubscriptions[characteristic] =
                characteristic.lastValueStream.listen((value) {
              if (!mounted) return; // Exit early if not mounted
              // // debugPrint(
              // // 'Received SPO2 Data: ${value.map((byte) => byte.toRadixString(16)).join(' ')}');
              debugPrint(
                  'Received Data: ${service.serviceUuid.toString()} $value  + ${value.length} ');
              if (value.length <= 7) {
                setState(() {
                  parseReceivedData(value);
                  healthStatus = checkHealthStatus(
                      systolicBP: SYSTOLICBP!,
                      diastolicBP: DIASTOLICBP!,
                      heartRate: HEARTRATE!,
                      spo2: SPO2!,
                      temperature: TEMPERATURE!,
                      ecgBpm: ECG!);

                  if (HEARTRATE != 0) {
                    _saveChanges('heart_rate', HEARTRATE);
                  }
                  if (SYSTOLICBP != 0) {
                    _saveChanges('blood_pressure_systolic', SYSTOLICBP);
                  }
                  if (DIASTOLICBP != 0) {
                    _saveChanges('blood_pressure_diastolic', DIASTOLICBP);
                  }
                  if (TEMPERATURE != 0) {
                    _saveChanges('temperature', TEMPERATURE);
                  }
                  // if (SPO2 != 0) {
                  //   _saveChanges('spo2', SPO2);
                  // }
                  // if (ECG!= 0) {
                  //   _saveChanges('ecg_bpm', ECG);
                  // }

                  HealthStorage.saveHealthData(
                      image: _imageUrl!,
                      name: profile.name!,
                      street: _street,
                      country: _country,
                      //
                      heartRate: HEARTRATE!,
                      bloodPressure: BLOODPRESSURE!,
                      spo2: SPO2!,
                      temperature: TEMPERATURE!,
                      ecg: ECG!,
                      //
                      heartRateStatus: heartRateStatus!,
                      bloodPressureStatus: bloodPressureStatus!,
                      spo2Status: spo2Status!,
                      temperatureStatus: temperatureStatus!,
                      ecgBpmStatus: ecgStatus!);
                });
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error discovering services or subscribing: $e');
    }
  }

  Map<String, String> checkHealthStatus(
      {required int systolicBP, // Example: 120
      required int diastolicBP, // Example: 80
      required int heartRate, // Example: 75
      required int spo2, // Example: 98
      required double temperature, // Example: 36.6
      required int ecgBpm // Example: 73
      }) {
    Map<String, String> status = {};
// Notifications
    if (systolicBP > 120 || diastolicBP > 80) {
      _showNotification("High Blood Pressure",
          "Your BP is $systolicBP/$diastolicBP mmHg! Seek medical attention.");
    } else if (diastolicBP > 80 || heartRate > 0) {
      _showNotification("High Heart Rate",
          "Your HR is $heartRate bpm! Possible Tachycardia.");
    }

    if (heartRate > 100) {
      _showNotification("High Heart Rate",
          "Your HR is $heartRate bpm! Possible Tachycardia.");
    } else if (heartRate < 60) {
      _showNotification(
          "Low Heart Rate", "Your HR is $heartRate bpm! Possible Tachycardia.");
    }

    if (spo2 < 90) {
      _showNotification(
          "Low SPO2", "Oxygen level is $spo2%! Critical condition.");
    }
    // Check Blood Pressure
    if (systolicBP >= 90 &&
        systolicBP <= 120 &&
        systolicBP != 0 &&
        diastolicBP >= 60 &&
        diastolicBP <= 80 &&
        diastolicBP != 0) {
      bloodPressureStatus = 'Normal';
      status["Blood Pressure"] = "Normal ($systolicBP/$diastolicBP mmHg)";
    } else if (systolicBP > 120 || diastolicBP > 80 && diastolicBP != 0) {
      bloodPressureStatus = 'Critical';
      status["Blood Pressure"] =
          "High BP ($systolicBP/$diastolicBP mmHg) - Hypertension Risk!";
    } else if (systolicBP <= 90 && systolicBP != 0 ||
        systolicBP <= 120 && diastolicBP != 0) {
      bloodPressureStatus = 'Critical';
      status["Blood Pressure"] =
          "Low BP ($systolicBP/$diastolicBP mmHg) - Hypotension Risk!";
    } else {
      bloodPressureStatus = 'Waiting';
      status["Blood Pressure"] = "Waiting for BP Data... ";
    }

    // Check Heart Rate
    if (heartRate >= 60 && heartRate <= 100) {
      heartRateStatus = 'Normal';
      status["Heart Rate"] = "Normal ($heartRate bpm)";
    } else if (heartRate > 100) {
      heartRateStatus = 'Critical';
      status["Heart Rate"] = "High HR ($heartRate bpm) - Possible Tachycardia!";
    } else if (heartRate < 60 && heartRate != 0) {
      heartRateStatus = 'Critical';
      status["Heart Rate"] = "Low HR ($heartRate bpm) - Possible Bradycardia!";
    } else {
      heartRateStatus = 'Waiting';
      status["Heart Rate"] = "Waiting for HR Data... ";
    }

    // Check SPO2 (Oxygen Saturation)
    if (spo2 >= 95 && spo2 <= 100) {
      spo2Status = 'Normal';
      status["SPO2"] = "Normal ($spo2%)";
    } else if (spo2 >= 90 && spo2 < 95) {
      spo2Status = 'Critical';
      status["SPO2"] = "Low SPO2 ($spo2%) - Possible Hypoxia!";
    } else if (spo2 <= 90 && spo2 != 0) {
      spo2Status = 'Critical';
      status["SPO2"] = "Critical SPO2 ($spo2%) - Seek Medical Help!";
    } else {
      spo2Status = 'Waiting';
      status["SPO2"] = "Waiting for SPO2 Data... ";
    }

    // Check Temperature
    if (temperature >= 36.1 && temperature <= 37.5) {
      temperatureStatus = 'Normal';
      status["Temperature"] = "Normal ($temperature°C)";
    } else if (temperature > 37.5) {
      temperatureStatus = 'Critical';
      status["Temperature"] = "High Temp ($temperature°C) - Possible Fever!";
    } else if (temperature < 37.5 && temperature != 0) {
      temperatureStatus = 'Critical';
      status["Temperature"] =
          "Low Temp ($temperature°C) - Possible Hypothermia!";
    } else {
      temperatureStatus = 'Waiting';
      status["Temperature"] = "Waiting for Temperature Data... ";
    }

    // Check ECG (Heart Rate from ECG)
    if (ecgBpm >= 60 && ecgBpm <= 100) {
      ecgStatus = 'Normal';
      status["ECG"] = "Normal ($ecgBpm bpm)";
    } else if (ecgBpm > 100) {
      ecgStatus = 'Critical';
      status["ECG"] = "High ECG BPM ($ecgBpm bpm) - Arrhythmia Risk!";
    } else if (ecgBpm < 60 && ecgBpm != 0) {
      ecgStatus = 'Critical';
      status["ECG"] = "Low ECG BPM ($ecgBpm bpm) - Possible Heart Block!";
    } else {
      ecgStatus = 'Waiting';
      status["ECG"] = "Waiting for ECG Data... ";
    }

    return status;
  }

  void parseReceivedData(List<int> characteristicProperties) {
    if (characteristicProperties.isEmpty) return;

    int key = characteristicProperties[1]; // Identifier
    int value1 = characteristicProperties[4];
    int value2 =
        characteristicProperties.length > 5 ? characteristicProperties[5] : 0;
    int value3 =
        characteristicProperties.length > 6 ? characteristicProperties[6] : 0;

    switch (key) {
      case 93: // Blood Pressure
        int systolic = value1;
        int diastolic = value2;
        SYSTOLICBP = systolic;
        DIASTOLICBP = diastolic;
        BLOODPRESSURE = '$systolic / $diastolic}';
        print('Blood Pressure: $systolic/$diastolic mmHg');
        break;

      case 94: // SPO2
        SPO2 = value1;
        print('SPO2: $value1%');
        break;

      case 92: // Heart Rate
        HEARTRATE = value1;
        print('Heart Rate: $value1 bpm');
        break;

      case 91: // Temperature
        int rawTemp = (value2 << 8) | value1; // Combine bytes
        double temperature = rawTemp / 10.0;
        TEMPERATURE = temperature;

        print('Temperature: ${temperature.toStringAsFixed(1)}°C');
        break;

      case 120: // ECG (Fixed)
        int ecgBpm = value2; // ECG value directly from index 5
        ECG = ecgBpm;
        print('ECG: $ecgBpm bpm ');
        break;

      default:
        print('Unknown Data Received: $characteristicProperties');
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final connectedDev = ref.watch(connectedDevProvProvider);
      print(connectedDev);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const Icon(
          Icons.location_on_outlined,
          color: Colors.white,
          size: 20,
        ),
        leadingWidth: 10.w,
        title: _locationError != null
            ? Text(
                _locationError!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              )
            : _currentPosition != null
                ? Text(
                    '$_street,$_country ',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  )
                : const Text(
                    'Fetching location...',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider
                          : (_imageUrl != null && _imageUrl!.isNotEmpty
                              ? NetworkImage(_imageUrl!)
                              : const AssetImage('assets/Ellipse 4.png')
                                  as ImageProvider),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6.h,
                      children: [
                        CustomTextWidget(
                            'Welcome', AppConstants.white, 12, FontWeight.bold),
                        CustomTextWidget(profile.name ?? "Fetching Data...",
                            AppConstants.white, 16, FontWeight.bold),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomCard(
                  'assets/blood.png',
                  'Blood Pressure',
                  BLOODPRESSURE != ''
                      ? '${BLOODPRESSURE!.replaceAll('}', '')} mmHg'
                      : '${healthData['BLOODPRESSURE']} mmHg',
                  bloodPressureStatus,
                  healthStatus['Blood Pressure'],
                ),
                CustomCard(
                    'assets/pulse.png',
                    'Heart Rate',
                    HEARTRATE != 0
                        ? '${HEARTRATE!.toString().replaceAll('}', '')} bpm'
                        : '${healthData['HEARTRATE']} bpm',
                    heartRateStatus,
                    healthStatus['Heart Rate']),
                CustomCard(
                    'assets/temp.png',
                    'Temperature',
                    TEMPERATURE != 0
                        ? '${TEMPERATURE!.toString().replaceAll('}', '')} °C'
                        : '${healthData['TEMPERATURE']} °C',
                    temperatureStatus,
                    healthStatus['Temperature']),
                CustomCard(
                    'assets/suger.png',
                    'ECG',
                    ECG != 0
                        ? '${ECG!.toString().replaceAll('}', '')} bpm'
                        : '${healthData['ECG']} bpm',
                    ecgStatus,
                    healthStatus['ECG']),
                CustomCard(
                    'assets/spo2.png',
                    'SPO2',
                    SPO2 != 0
                        ? '${SPO2!.toString().replaceAll('}', '')} SPO2'
                        : '${healthData['SPO2']} SPO2',
                    spo2Status,
                    healthStatus['SPO2']),

                SizedBox(
                  height: 15.h,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
