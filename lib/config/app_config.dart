import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slic/flavors.dart';

class ApiConfig {
  static Flavor appFlavor = F.appFlavor!;

  static String get appName => F.name;
  static String get appTitle => F.title;

  static String get slicDomain => appFlavor == Flavor.dev
      ? dotenv.env['SLIC_TESTING']!
      : dotenv.env['SLIC_LIVE']!;
  static String get nartecDomain => appFlavor == Flavor.dev
      ? dotenv.env['NARTEC_TESTING']!
      : dotenv.env['NARTEC_LIVE']!;
}
