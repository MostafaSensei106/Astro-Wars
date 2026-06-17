import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class MaterialRouteData extends GoRouteData {
  const MaterialRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(child: build(context, state));
}
