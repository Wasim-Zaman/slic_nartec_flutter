import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // static String slicDomain = dotenv.env['SLIC_TESTING']!;
  // static String nartecDomain = dotenv.env['NARTEC_TESTING']!;

  static String slicDomain = dotenv.env['SLIC_LIVE']!;
  static String nartecDomain = dotenv.env['NARTEC_LIVE']!;
}
