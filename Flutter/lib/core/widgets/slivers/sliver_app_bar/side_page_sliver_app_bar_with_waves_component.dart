// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_config.dart';
import '../../animation/wave_background.dart';

final class SidePageSliverAppBarWithWavesComponent extends HookWidget {
  const SidePageSliverAppBarWithWavesComponent({
    required this.scrollController,
    required this.title,
    super.key,
    this.actions,
    this.pinned = true,
    this.floating = false,
    this.expandedHeight = 180.0,
    this.waveColor,
    this.secondaryWaveColor,
    this.backgroundColor,
    this.flexibleSpace,
    this.centerTitle = true,
    this.showBackButton = true,
    this.bottom,
  });

  final String title;
  final List<Widget>? actions;
  final bool pinned;
  final bool floating;
  final double expandedHeight;
  final Color? waveColor;
  final Color? secondaryWaveColor;
  final Color? backgroundColor;
  final Widget? flexibleSpace;
  final bool centerTitle;
  final bool showBackButton;
  final ScrollController scrollController;
  final PreferredSizeWidget? bottom;

  void leave(final BuildContext context) {
    unawaited(HapticFeedback.vibrate());
    context.pop();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // 1. Animation Controller for Waves
    final controller = useAnimationController(
      duration: const Duration(seconds: 4),
    )..repeat();

    // 2. Track expanded state
    final isExpanded = useState(true);

    useEffect(() {
      void scrollListener() {
        final expanded =
            scrollController.hasClients &&
            scrollController.offset < (expandedHeight - 80);
        if (isExpanded.value != expanded) {
          isExpanded.value = expanded;
        }
      }

      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, [scrollController, expandedHeight]);

    return SliverAppBar(
      pinned: pinned,
      floating: floating,
      expandedHeight: expandedHeight,
      title: _AppBarTitle(
        isExpanded: isExpanded.value,
        title: title,
        colorScheme: colorScheme,
      ),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: isExpanded.value
          ? (backgroundColor ?? colorScheme.primary)
          : colorScheme.surface.withValues(alpha: 0.7),
      foregroundColor: isExpanded.value
          ? colorScheme.onPrimary
          : colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 4),
      bottom: bottom,

      leading: showBackButton
          ? Center(
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConfig.outBorderRadius,
                    ),
                  ),
                ),
                onPressed: () => leave(context),
                icon: Icon(
                  isRtl
                      ? Icons.keyboard_double_arrow_right_rounded
                      : Icons.keyboard_double_arrow_left_rounded,
                  size: AppConfig.iconSize,
                ),
                color: colorScheme.onPrimaryContainer,
              ),
            )
          : null,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            background: Stack(
              children: [
                Container(color: backgroundColor ?? colorScheme.primary),
                // Secondary Wave (Layer back)
                Positioned.fill(
                  child: WaveBackground(
                    animation: controller,
                    color:
                        secondaryWaveColor ??
                        colorScheme.surface.withValues(alpha: 0.5),
                    reverse: true,
                    amplitude: 20,
                    waveHeight: 80,
                  ),
                ),
                // Primary Wave (Layer front)
                Positioned.fill(
                  child: WaveBackground(
                    animation: controller,
                    color: waveColor ?? colorScheme.surface,
                  ),
                ),
                ?flexibleSpace,
              ],
            ),
          ),
          if (!isExpanded.value)
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    required this.isExpanded,
    required this.title,
    required this.colorScheme,
  });

  final bool isExpanded;
  final String title;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        title,
        key: ValueKey<String>('$title-$isExpanded'),
        style: TextStyle(
          color: isExpanded ? colorScheme.onPrimary : colorScheme.onSurface,
        ),
      ),
    );
  }
}
