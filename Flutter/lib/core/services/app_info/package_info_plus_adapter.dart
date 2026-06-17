import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'interface/base_package_info_adapter.dart';

@LazySingleton(as: BasePackageInfoAdapter)
final class PackageInfoPlusAdapter implements BasePackageInfoAdapter {
  PackageInfoPlusAdapter(this._info);
  final PackageInfo _info;

  @override
  PackageInfo get packageInfo => _info;
}
