import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../widgets/buttons/branded_button.dart';

class SelectionDialog<T> extends HookWidget {
  final Function(T) callback;
  final List<T> options;
  final T value;
  final String title;
  final String Function(T) renderTitleCallback;

  const SelectionDialog({
    Key? key,
    required this.callback,
    required this.options,
    required this.value,
    required this.title,
    required this.renderTitleCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useState<T>(value);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Color(0xFF05889C)),
            ),
            SizedBox(
              height: 12,
            ),
            ...options.map(
              ((e) => RadioListTile<T>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(renderTitleCallback(e)),
                    contentPadding: EdgeInsets.zero,
                    value: e,
                    groupValue: state.value,
                    onChanged: (v) => state.value = v ?? state.value,
                  )),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: BrandedButton(
                    onPressed: () {
                      callback(state.value);
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
