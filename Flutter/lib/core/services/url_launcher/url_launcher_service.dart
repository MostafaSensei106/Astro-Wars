import 'package:url_launcher/url_launcher.dart';

import 'base_url_launcher_services.dart';

final class UrlLauncherService implements BaseUrlLauncherServices {
  @override
  Future<void> launchWebsite({required String url}) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Future<void> launchEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final query = [
      'subject=${Uri.encodeComponent(subject)}',
      'body=${Uri.encodeComponent(body)}',
    ].join('&');

    final uri = Uri(scheme: 'mailto', path: to, query: query);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch email $uri');
    }
  }

  @override
  Future<void> callPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch $uri');
    }
  }
}
