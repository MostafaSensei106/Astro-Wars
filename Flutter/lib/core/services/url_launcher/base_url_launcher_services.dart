abstract class BaseUrlLauncherServices {
  Future<void> launchWebsite({required String url});

  Future<void> launchEmail({
    required String to,
    required String subject,
    required String body,
  });

  Future<void> callPhone(String phoneNumber);
}
