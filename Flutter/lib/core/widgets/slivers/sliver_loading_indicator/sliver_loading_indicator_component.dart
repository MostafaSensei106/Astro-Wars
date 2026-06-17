import 'package:flutter/material.dart';
import '../../feedback/loading_indicator/loading_indicator_component.dart';

class SliverLoadingIndicatorComponent extends StatelessWidget {
  const SliverLoadingIndicatorComponent({super.key, this.value});
  final double? value;

  @override
  Widget build(final BuildContext context) =>
      SliverToBoxAdapter(child: LoadingIndicatorComponent(value: value));
}
