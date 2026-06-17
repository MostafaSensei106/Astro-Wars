import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

abstract class BaseShareService {
  Future<void> shareUrl({
    required String url,
    String? subject,
    Rect? sharePosition,
  });
  Future<bool> shareFile({
    required XFile file,
    String? text,
    String? subject,
    Rect? sharePosition,
  });
  Future<void> shareText({
    required String text,
    String? subject,
    Rect? sharePosition,
  });
}
