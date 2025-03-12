import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slic/utils/shared_storage.dart';

import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedStorage.init();
  await dotenv.load(fileName: '.env');

  runApp(const App());
}
