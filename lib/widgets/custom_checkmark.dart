import 'package:flutter/material.dart';
import 'package:neo/style/theme.dart';

enum CheckmarkState { ok, error, unknown }

class CustomCheckmark extends StatelessWidget {
  final CheckmarkState state;
  final String label;
  const CustomCheckmark({Key? key, required this.state, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: state == CheckmarkState.ok
                  ? NeoTheme.of(context)!.positiveColor
                  : state == CheckmarkState.error
                      ? NeoTheme.of(context)!.negativeColor
                      : Colors.grey,
            ),
            child: Icon(
              state == CheckmarkState.ok
                  ? Icons.check
                  : state == CheckmarkState.error
                      ? Icons.close
                      : Icons.question_mark,
              size: 15,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 7.5,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
