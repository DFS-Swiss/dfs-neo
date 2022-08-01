import 'package:flutter/material.dart';

class TutorialContent extends StatelessWidget {
  final String image;
  final String headline;
  final String subtext;
  const TutorialContent(
      {Key? key,
      required this.image,
      required this.headline,
      required this.subtext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55),
            child: Image.asset(image),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headline,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Color(0xFF05889C)),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                subtext,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        )
      ],
    );
  }
}
