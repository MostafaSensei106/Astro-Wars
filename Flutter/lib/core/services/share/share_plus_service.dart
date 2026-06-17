import 'dart:ui';

import 'package:share_plus/share_plus.dart';

import 'base_share_service.dart';

final class SharePlusService implements BaseShareService {
  @override
  Future<bool> shareFile({
    required XFile file,
    String? text,
    String? subject,
    Rect? sharePosition,
  }) async {
    try {
      final params = ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: sharePosition,
        files: [file],
      );
      final res = await SharePlus.instance.share(params);
      return res.status == ShareResultStatus.success;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> shareText({
    required String text,
    String? subject,
    Rect? sharePosition,
  }) async {
    final params = ShareParams(
      text: text,
      subject: subject,
      sharePositionOrigin: sharePosition,
    );
    await SharePlus.instance.share(params);
  }

  @override
  Future<void> shareUrl({
    required String url,
    String? subject,
    Rect? sharePosition,
  }) async {
    final params = ShareParams(
      text: url,
      subject: subject,
      sharePositionOrigin: sharePosition,
    );
    await SharePlus.instance.share(params);
  }
}
