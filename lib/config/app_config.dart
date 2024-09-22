import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String slicDomain = dotenv.env['SLIC_TESTING']!;
}
