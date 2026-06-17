import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../../l10n/app_localizations.dart';

@lazySingleton
final class L10nService {
  AppLocalizations get(BuildContext context) => AppLocalizations.of(context)!;
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}
