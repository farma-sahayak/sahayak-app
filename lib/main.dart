import 'package:flutter/material.dart';
import 'package:mobile/core/di/di.dart';
import 'package:mobile/sahayak_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencyInjection();

  runApp(const SahayakApp());
}
