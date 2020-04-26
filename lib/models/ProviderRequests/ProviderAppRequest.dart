import 'dart:convert';

import '../Provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderAppRequest extends ProviderRequest {
  ProviderAppRequest(String url) : super(url);

  @override
  Future<String> send() async => jsonEncode(await canLaunch(url)
        ? ProviderResponse(await launch(url), pendingResponse: true).toMap()
        : ProviderResponse(false, error: 'could not launch app').toMap());
}
