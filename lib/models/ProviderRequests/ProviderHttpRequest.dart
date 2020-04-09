import 'package:http/http.dart';

import '../Provider.dart';

class ProviderHttpRequest extends ProviderRequest {
  Map<String, String> headers;
  String body;

  ProviderHttpRequest(String url, {this.body, this.headers}): super(url);

  @override
  Future<String> send() async {
    final res = await post(url,
        body: body,
        headers: headers);
    return res.body;
  }
}
