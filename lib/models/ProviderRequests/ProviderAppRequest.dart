import '../Provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderAppRequest extends ProviderRequest {
  ProviderAppRequest(String url): super(url);

  @override
  Future<String> send() async {
    if (await canLaunch(url)) {
      await launch(url);
      return '{ok:true}';
    } else {
      throw 'Could not launch $url';
    }
  }
}