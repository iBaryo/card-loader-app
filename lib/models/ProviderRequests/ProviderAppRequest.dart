import 'dart:convert';

import '../Provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderAppRequest extends ProviderRequest {
  ProviderAppRequest(String url) : super(url);

  @override
  Future<String> send() async {
    if (await canLaunch(url)) {
      return jsonEncode({'ok': await launch(url)});
    } else {
      throw 'Could not launch $url';
    }
  }
}
