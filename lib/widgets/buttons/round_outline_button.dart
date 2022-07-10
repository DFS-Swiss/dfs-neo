import 'package:flutter/material.dart';

class RoundOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool loading;
  const RoundOutlineButton({
    Key? key,
    required this.onPressed,
    this.loading = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      width: 44.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          child: loading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
