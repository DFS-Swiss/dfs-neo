import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/style/theme.dart';

class GenericHeadline extends HookWidget {
  final String title;
  final Function? callback;
  final String? linktext;
  const GenericHeadline(
      {this.callback, this.linktext, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12, top: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          linktext != null && callback != null
              ? GestureDetector(
                  onTap: () {
                    callback!();
                  },
                  child: Text(
                    linktext!,
                    style: NeoTheme.of(context)!.linkTextStyle,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
