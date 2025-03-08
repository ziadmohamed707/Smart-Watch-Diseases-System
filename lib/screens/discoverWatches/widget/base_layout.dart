// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_elevated_button.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

import '/provider/scan_result_prov.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseLayout extends ConsumerStatefulWidget {
  bool isHome;
  final Widget child;
  BaseLayout({super.key, required this.child, this.isHome = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends ConsumerState<BaseLayout> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results
          .where((r) => r.device.platformName.isNotEmpty)
          .toSet()
          .toList();
      ref.read(scanResultProvProvider.notifier).setScanResult(_scanResults);
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      debugPrint('Error: $e');
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
// Battery Level Service
    } catch (e) {
      debugPrint('Error: $e');
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      debugPrint('Error: $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              iconSize: 30,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              }),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 15),
              child: CustomTextWidget(
                'Discover Your \nWatch',
                AppConstants.white,
                30,
                FontWeight.bold,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: widget.child,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: CustomElevatedButton(
                context,
                "Start",
                AppConstants.purple,
                AppConstants.white,
                () {
                  if (_isScanning) {
                    FlutterBluePlus.stopScan();
                  } else {
                    onScanPressed();
                  }
                },
              ),
            ),
            CustomElevatedButton(
              context,
              "Scan for Device",
              AppConstants.white,
              AppConstants.transparent,
              () {
                if (_isScanning) {
                  FlutterBluePlus.stopScan();
                } else {
                  onScanPressed();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
