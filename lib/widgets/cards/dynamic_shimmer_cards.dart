import 'package:flutter/material.dart';
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
        padding:  EdgeInsets.only(left: sidePadding, right: sidePadding, bottom: bottomPadding),
        child: Shimmer.fromColors(
          baseColor: Color.fromRGBO(238, 238, 238, 0.75),
          highlightColor: Colors.white,
          child: Container(
            height: cardHeight,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        ),
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
