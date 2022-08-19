import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/hooks/use_brightness.dart';
import 'package:neo/style/theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingCard extends HookWidget {
  final double height;
  final double? width;
  const ShimmerLoadingCard({Key? key, required this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = useBrightness();
    return Shimmer.fromColors(
      baseColor: brightness == Brightness.dark
          ? Theme.of(context).backgroundColor.withOpacity(0.75)
          : Color.fromRGBO(238, 238, 238, 0.75),
      highlightColor:
          brightness == Brightness.dark
              ? NeoTheme.of(context)!.primaryColor
              : Colors.white,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
