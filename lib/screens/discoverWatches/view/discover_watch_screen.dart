import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iot_monitoring_chronic_diseases_system/provider/connected_dev_prov.dart';
import 'package:iot_monitoring_chronic_diseases_system/provider/scan_result_prov.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/extra.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/snackbar.dart';
import 'package:iot_monitoring_chronic_diseases_system/screens/discoverWatches/widget/base_layout.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

class DiscoverWatchScreen extends ConsumerStatefulWidget {
  const DiscoverWatchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiscoverWatchScreenState();
}

class _DiscoverWatchScreenState extends ConsumerState<DiscoverWatchScreen> {
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  Future<void> checkBluetooth() async {
    var isOn = await FlutterBluePlus.isOn;
    if (!isOn) {
      debugPrint("Bluetooth is OFF. Please enable it.");
    }
  }

  void onConnectPressed(BluetoothDevice device, int index) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    }).then((_) async {
      if (device.isConnected) {
        ref
            .read(connectedDevProvProvider.notifier)
            .setConnectedDev(ref.read(scanResultProvProvider)[index]);
        debugPrint('Connected to ${device.platformName}');

        context.push('/home_screen');
      } else {
        Snackbar.show(ABC.c, 'Failed to connect', success: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      isHome: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: ref.watch(scanResultProvProvider).length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(30, 255, 255, 255),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              FlutterBluePlus.stopScan();
                              onConnectPressed(
                                  ref
                                      .watch(scanResultProvProvider)[index]
                                      .device,
                                  index);
                            },
                            child: Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: 1,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 56,
                                  width: 53,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10), // Image border
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(10), // Image radius
                                      child: Image.asset(
                                          'assets/smartwatchpic.jpg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: CustomTextWidget(
                                      ref
                                          .watch(scanResultProvProvider)[index]
                                          .device
                                          .platformName,
                                      AppConstants.white,
                                      12,
                                      FontWeight.bold),
                                ),
                                SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    );
                  })),
        ],
      ),
    );
  }
}
