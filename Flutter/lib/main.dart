import 'package:astro/astro_wars_app.dart';
import 'package:flutter/material.dart';

import 'core/utils/sys_init/sys_init.dart';

void main() async {
  await SysInit.startDaemons();
  runApp(const AstroWarsApp());
}
