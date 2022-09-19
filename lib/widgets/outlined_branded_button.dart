import 'package:flutter/material.dart';

import '../style/theme.dart';

class OutlinedBrandedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  const OutlinedBrandedButton(
      {Key? key, required this.text, this.onPressed, this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        borderRadius: NeoTheme.of(context)!.primaryBorderRadius,
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
      ),
    );
  }
}
