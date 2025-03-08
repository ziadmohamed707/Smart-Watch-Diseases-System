class Watchdetails {
  int? heartRate;
  int? bloodPressureSystolic;
  int? bloodPressureDiastolic;
  int? spo2;
  int? ECG;
  double? temperature;
  String? recordedAt;

  Watchdetails({
    this.heartRate,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.spo2,
    this.ECG,
    this.temperature,
    this.recordedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'heart_rate': heartRate,
      'blood_pressure_systolic': bloodPressureSystolic,
      'blood_pressure_diastolic': bloodPressureDiastolic,
      'spo2': spo2,
      'ECG': ECG,
      'temperature': temperature,
      'recorded_at': recordedAt,
    };
  }

  static Watchdetails fromMap(Map<String, dynamic> map) {
    return Watchdetails(
      heartRate: map['heart_rate'],
      bloodPressureSystolic: map['blood_pressure_systolic'],
      bloodPressureDiastolic: map['blood_pressure_diastolic'],
      spo2: map['spo2'],
      ECG: map['ECG'],
      temperature: map['temperature'],
      recordedAt: map['recorded_at'],
    );
  }

  @override
  String toString() {
    return 'Watchdetails{heart_rate: $heartRate, blood_pressure_systolic: $bloodPressureSystolic, blood_pressure_diastolic: $bloodPressureDiastolic, spo2; $spo2,ecg: $ECG ,temperature: $temperature, recorded_at: $recordedAt}';
  }
}
