import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class HealthHelper {
  static final Health _health = Health();
  static bool _configured = false;

  static Future<void> _ensureConfigured() async {
    if (!_configured) {
      try {
        await _health.configure();
        _configured = true;
      } catch (e) {
        debugPrint("Error configuring health package: $e");
      }
    }
  }

  static Future<bool> hasPermissions() async {
    await _ensureConfigured();
    final types = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED];
    final permissions = [HealthDataAccess.READ, HealthDataAccess.READ];
    try {
      return await _health.hasPermissions(types, permissions: permissions) ?? false;
    } catch (e) {
      debugPrint("Error checking health permissions: $e");
      return false;
    }
  }

  static Future<bool> requestPermissions() async {
    await _ensureConfigured();
    final types = [HealthDataType.STEPS, HealthDataType.ACTIVE_ENERGY_BURNED];
    final permissions = [HealthDataAccess.READ, HealthDataAccess.READ];
    try {
      bool authorized = await _health.requestAuthorization(types, permissions: permissions);
      return authorized;
    } catch (e) {
      debugPrint("Error requesting health permissions: $e");
      return false;
    }
  }

  static Future<Map<String, int>> getTodayActivity() async {
    await _ensureConfigured();
    bool authorized = await hasPermissions();
    if (!authorized) {
      return {'steps': 0, 'calories': 0};
    }

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    int steps = 0;
    int calories = 0;

    try {
      List<HealthDataPoint> stepsRecords = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: midnight,
        endTime: now,
      );
      for (var record in stepsRecords) {
        if (record.value is NumericHealthValue) {
          steps += (record.value as NumericHealthValue).numericValue.toInt();
        } else {
          final numericVal = double.tryParse(record.value.toString()) ?? 0.0;
          steps += numericVal.toInt();
        }
      }

      // Get active calories burned records and sum them up
      List<HealthDataPoint> caloriesRecords = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: midnight,
        endTime: now,
      );
      for (var record in caloriesRecords) {
        if (record.value is NumericHealthValue) {
          calories += (record.value as NumericHealthValue).numericValue.toInt();
        } else {
          final numericVal = double.tryParse(record.value.toString()) ?? 0.0;
          calories += numericVal.toInt();
        }
      }
    } catch (e) {
      debugPrint("Error reading fitness data: $e");
    }

    return {'steps': steps, 'calories': calories};
  }
}
