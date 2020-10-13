import 'package:url_launcher/url_launcher.dart';

import 'package:qr_reader/src/models/scan.dart';

class FunctionUtils {
  static navigateToUrl(Scan scan) async {
    if (scan.value.contains("http")) {
      if (await canLaunch(scan.value)) {
        await launch(scan.value);
      } else {
        throw "No se pudo navegar a ${scan.value}";
      }
    }
  }
}
