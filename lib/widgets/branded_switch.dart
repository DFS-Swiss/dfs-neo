import 'package:flutter/material.dart';

class BrandedSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  const BrandedSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged, // onChanged,
      activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
      activeColor: Theme.of(context).primaryColor,
    );
  }
}
