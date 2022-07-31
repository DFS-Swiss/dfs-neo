import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/buttons/branded_button.dart';

class SwitchRow extends HookWidget {
  final List<SwitchRowItem> options;

  const SwitchRow({
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 4,
            ),
            ...options,
            SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchRowItem<T> extends StatelessWidget {
  const SwitchRowItem({
    Key? key,
    required this.selected,
    required this.callback,
    required this.value,
    required this.text,
  }) : super(key: key);

  final bool selected;
  final Function(T) callback;
  final T value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: selected
            ? BrandedButton(
                onPressed: () {},
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14),
                ),
              )
            : TextButton(
                onPressed: () {
                  callback(value);
                },
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14),
                ),
              ),
      ),
    );
  }
}
