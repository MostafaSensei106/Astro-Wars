import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../utils/models/app_info_model.dart';
import 'interface/base_app_info_service.dart';
import 'interface/base_package_info_adapter.dart';

@LazySingleton(as: BaseAppInfoService)
final class AppInfoService implements BaseAppInfoService {
  AppInfoService(this._appInfo);
  final BasePackageInfoAdapter _appInfo;

  @override
  AppInfoModel getAppDetails() {
    final i = _appInfo.packageInfo;
    final dartVersionFull = Platform.version;
    String? dartChannelStr;
    if (dartVersionFull.contains('(') && dartVersionFull.contains(')')) {
      dartChannelStr = dartVersionFull.split('(')[1].split(')')[0];
    }

    return AppInfoModel(
      appName: i.appName,
      packageName: i.packageName,
      version: i.version,
      buildNumber: i.buildNumber,
      operatingSystemName: Platform.operatingSystem,
      operatingSystemVersion: Platform.operatingSystemVersion,
      dartChanal: dartChannelStr,
      dartVersion: dartVersionFull.split(' ').first,
      flutterChanal: FlutterVersion.channel,
      flutterVersion: FlutterVersion.version,
      installDate: i.installTime,
      updateTime: i.updateTime,
      installerStore: i.installerStore,
      isDebug: kDebugMode,
    );
  }
}
