import 'package:flutter/material.dart';
import 'package:neo/widgets/shimmer_loader_card.dart';
import 'package:shimmer/shimmer.dart';

class DynamicShimmerCards extends StatelessWidget {
  final int cardAmount;
  final double cardHeight;
  final double bottomPadding;
  final double sidePadding;

  const DynamicShimmerCards(
      {Key? key,
      required this.cardAmount,
      required this.cardHeight,
      required this.bottomPadding,
      required this.sidePadding})
      : super(key: key);

  List<Widget> generateChildren() {
    List<Widget> result = [];
    for (int i = 0; i < cardAmount; i++) {
      result.add(Padding(
        padding: EdgeInsets.only(
            left: sidePadding, right: sidePadding, bottom: bottomPadding),
        child: ShimmerLoadingCard(height: cardHeight),
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: generateChildren(),
    );
  }
}
