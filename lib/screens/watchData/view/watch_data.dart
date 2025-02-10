import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_monitoring_chronic_diseases_system/provider/connected_dev_prov.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/discoverWatches/widget/base_layout.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_app_bar_spacer.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_card.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

class WatchDataScreen extends ConsumerStatefulWidget {
  const WatchDataScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WatchDataScreenState();
}

class _WatchDataScreenState extends ConsumerState<WatchDataScreen> {
  List<BluetoothCharacteristic> sensorCharacteristics = [];
  final List<String> _decodedHeartRateValue = [];
  final List<String> _decodedBloodPressureValue = [];
  final List<String> _decodedSPO2Value = [];

  Map<BluetoothCharacteristic, StreamSubscription<List<int>>>
      _sensorSubscriptions = {};

  @override
  void initState() {
    super.initState();
    _readAndSubscribeCharacteristics();
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

  Future<void> onSubscribe(BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.setNotifyValue(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Subscribed to ${characteristic.uuid}"),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Subscribe Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  void processSensorData(data, index) {
    if (data.isNotEmpty) {
      if (index == 0) {
        _decodedHeartRateValue.add(data);
      } else if (index == 1) {
        _decodedBloodPressureValue.add(data);
      } else if (index == 2) {
        _decodedSPO2Value.add(data.toString());
      }
      setState(() {}); // Update UI with new data
    }
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
          if (service.uuid.toString().toLowerCase() == '00006287-3c17-d293-8e48-14fe2e4da212' ||
              service.uuid.toString().toLowerCase() == '1801' ||
              service.uuid.toString().toLowerCase() == '1800' ||
              service.uuid.toString().toLowerCase() ==
                  '0000d0ff-3c17-d293-8e48-14fe2e4da212' ||
              service.uuid.toString().toLowerCase() ==
                  '0000d0ff-3c17-d293-8e48-14fe2e4da212' ||
              characteristic.uuid.toString().toLowerCase() == '3802' ||
              characteristic.properties.notify) {
            sensorCharacteristics.add(characteristic);
            await onSubscribe(characteristic);

            _sensorSubscriptions[characteristic] =
                characteristic.lastValueStream.listen((value) {
              if (!mounted) return; // Exit early if not mounted
              // // debugPrint(
              // // 'Received SPO2 Data: ${value.map((byte) => byte.toRadixString(16)).join(' ')}');
              debugPrint(
                  'Received Data: ${service.serviceUuid.toString()} ${value}  + ${value.length} ');
              try {
                if (value.length == 6) {
                  {
                    List<int> reads = value;
                    processSensorData("$reads", 0);
                  }
                  List<int> reads2 = value;
                  processSensorData("$reads2", 2);
                }
              } catch (e) {
                debugPrint('Failed to decode  data: $e');
              }
            });
            _sensorSubscriptions[characteristic] =
                characteristic.onValueReceived.listen((value) {
              if (!mounted) return; // Exit early if not mounted
              // // debugPrint(
              // // 'Received SPO2 Data: ${value.map((byte) => byte.toRadixString(16)).join(' ')}');
              debugPrint(
                  'Received Data: ${service.serviceUuid.toString()} + $CharacteristicProperties ${value}  + ${value.length} ');
              try {
                if (value.length == 7) {
                  List<int> reads = value;
                  processSensorData("$reads", 1);
                }
              } catch (e) {
                debugPrint('Failed to decode  data: $e');
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error discovering services or subscribing: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
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

    String splitData(data, index) {
      List<String> splitValues = data.split(', ');
      String Value = '0';

      if (splitValues.length >= 4) {
        if (splitValues.length == 6) {
          if (index == 'SPO2') {
            Value = splitValues[5];
          } else if (index == 'HEARTRATE') {
            Value = splitValues[5];
          }
        } else if (splitValues.length == 7) {
          if (index == 'BLOODPRESSURE') {
            Value = '${splitValues[4]}/${splitValues[5]}';
          }
        }
        return Value;
      } else {
        return "List does not have at least 4 values.";
      }
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
        leadingWidth: 10,
        title: const Text(
          'Riyadh, el street next to ezabby pharm',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage('assets/profile_pic.png'),
                    radius: 23,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      CustomTextWidget(
                          'Welcome', AppConstants.white, 12, FontWeight.bold),
                      CustomTextWidget('Amera Ahmed', AppConstants.white, 16,
                          FontWeight.bold),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              CustomCard(
                  'assets/blood.png',
                  'Blood Pressure',
                  _decodedBloodPressureValue.isNotEmpty
                      ? '${splitData(_decodedBloodPressureValue[_decodedBloodPressureValue.length - 1], 'BLOODPRESSURE')} mmHg'
                      : '0',
                  'state'),
              CustomCard(
                  'assets/pulse.png',
                  'Heart Rate',
                  _decodedHeartRateValue.isNotEmpty
                      ? '${splitData(_decodedHeartRateValue[_decodedHeartRateValue.length - 1], 'HEARTRATE').replaceAll(']', '')} bpm'
                      : '0 bpm',
                  'state'),
              CustomCard('assets/temp.png', 'Temperature', 'C', 'state'),
              CustomCard('assets/suger.png', 'Blood Sugar', 'data', 'state'),
              CustomCard(
                  'assets/spo2.png',
                  'SPO2',
                  _decodedSPO2Value.isNotEmpty
                      ? '${splitData(_decodedSPO2Value[_decodedSPO2Value.length - 1], 'SPO2').replaceAll(']', '')} SPO2'
                      : '0',
                  'state'),
            ],
          ),
        ],
      ),
    );
  }
}





// Container(
//                 margin: const EdgeInsets.only(bottom: 8),
//                 height: 400,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.grey,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: SingleChildScrollView(
//                   child: Text(
//                     _decodedHeartRateValue.join('\n'),
//                     overflow: TextOverflow.clip,
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _decodedHeartRateValue.clear();
//                   setState(() {});
//                 },
//                 child: const Text('Clear'),
//               ),