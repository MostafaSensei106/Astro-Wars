final class AppInfoModel {
  const AppInfoModel({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.operatingSystemName,
    required this.operatingSystemVersion,
    required this.dartChanal,

    required this.dartVersion,
    required this.flutterChanal,
    required this.flutterVersion,
    required this.installDate,
    required this.updateTime,
    required this.installerStore,
    required this.isDebug,
  });

  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String operatingSystemName;
  final String operatingSystemVersion;
  final String? dartChanal;
  final String dartVersion;
  final String? flutterChanal;
  final String? flutterVersion;
  final DateTime? installDate;
  final DateTime? updateTime;
  final String? installerStore;
  final bool isDebug;
}
