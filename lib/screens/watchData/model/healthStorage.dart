import 'package:shared_preferences/shared_preferences.dart';

class HealthStorage {
  // Save health data
  static Future<void> saveHealthData({
    required String name,
    required String image,
    required String street,
    required String country,
//
    required int heartRate,
    required String bloodPressure,
    required int spo2,
    required double temperature,
    required int ecg,
//
    required String bloodPressureStatus,
    required String heartRateStatus,
    required String spo2Status,
    required String temperatureStatus,
    required String ecgBpmStatus,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("NAME", name);
    await prefs.setString("IMAGE", image);
    await prefs.setString("STREET", street);
    await prefs.setString("COUNTRY", country);
//
    await prefs.setInt("HEARTRATE", heartRate);
    await prefs.setString("BLOODPRESSURE", bloodPressure);
    await prefs.setInt("SPO2", spo2);
    await prefs.setDouble("TEMPERATURE", temperature);
    await prefs.setInt("ECG", ecg);
//
    await prefs.setString("BLOODPRESSURESTATUS", bloodPressureStatus);
    await prefs.setString("HEARTRATESTATUS", heartRateStatus);
    await prefs.setString("SPO2STATUS", spo2Status);
    await prefs.setString("TEMPERATURESTATUS", temperatureStatus);
    await prefs.setString("ECGBPMSTATUS", ecgBpmStatus);
  }

  // Load health data
  static Future<Map<String, dynamic>> loadHealthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      "NAME": prefs.getString("NAME") ?? '',
      "IMAGE": prefs.getString("IMAGE") ?? '',
      "STREET": prefs.getString("STREET") ?? '',
      "COUNTRY": prefs.getString("COUNTRY") ?? '',
      //
      "HEARTRATE": prefs.getInt("HEARTRATE") ?? '--',
      "BLOODPRESSURE": prefs.getString("BLOODPRESSURE") ?? '--/--',
      "SPO2": prefs.getInt("SPO2") ?? '--',
      "TEMPERATURE": prefs.getDouble("TEMPERATURE") ?? '--',
      "ECG": prefs.getInt("ECG") ?? '--',
      //
      "BLOODPRESSURESTATUS": prefs.getString("BLOODPRESSURESTATUS") ?? 'Wating',
      "HEARTRATESTATUS": prefs.getString("HEARTRATESTATUS") ?? 'Wating',
      "SPO2STATUS": prefs.getString("SPO2STATUS") ?? 'Wating',
      "TEMPERATURESTATUS": prefs.getString("TEMPERATURESTATUS") ?? 'Wating',
      "ECGBPMSTATUS": prefs.getString("ECGBPMSTATUS") ?? 'Wating',
    };
  }
}
