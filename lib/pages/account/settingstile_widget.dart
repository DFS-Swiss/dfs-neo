import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/branded_switch.dart';

class SettingsTile extends HookWidget {
  final String text;
  final Function(bool) callback;
  final bool value;
  const SettingsTile({
    required this.text,
    required this.callback,
    Key? key,
    this.value = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).backgroundColor.withOpacity(0.75),
            border: Border.all(color: Theme.of(context).backgroundColor)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
              ),
              Expanded(child: Container()),
              BrandedSwitch(
                value: value,
                onChanged: callback,
              )
            ],
          ),
        ),
      ),
    );
  }
}
