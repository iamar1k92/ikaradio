import 'package:url_launcher/url_launcher.dart';

String generateErrorText(dynamic errorData) {
  String errorText = "";
  (errorData as Map<String, dynamic>).forEach((String key, dynamic errors) {
    (errors as List).forEach((error) {
      errorText += "$error \r\n";
    });
  });

  return errorText;
}


launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
