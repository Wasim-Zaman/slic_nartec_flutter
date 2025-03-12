import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slic/flavors.dart';

class ApiConfig {


  static String get slicDomain => F.appFlavor == Flavor.dev
      ? dotenv.env['SLIC_TESTING']!
      : dotenv.env['SLIC_LIVE']!;
  static String get nartecDomain => F.appFlavor == Flavor.dev
      ? dotenv.env['NARTEC_TESTING']!
      : dotenv.env['NARTEC_LIVE']!;
}
