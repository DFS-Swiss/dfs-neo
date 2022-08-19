import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/dialogs/selection_dialog.dart';
import 'package:neo/widgets/tiles/tile_position_enum.dart';

class SelectionTile<T> extends HookWidget {
  final String text;
  final Function(T) callback;
  final String Function(T) renderTitleCallback;
  final TilePosition position;
  final T value;
  final List<T> options;

  const SelectionTile({
    required this.text,
    required this.callback,
    required this.position,
    required this.value,
    required this.options,
    required this.renderTitleCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: position == TilePosition.standalone ? 8 : 0,
      ),
      child: InkWell(
        borderRadius: position.makeRadius(),
        splashColor: Theme.of(context).primaryColor,
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor.withOpacity(0.25),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SelectionDialog(
              callback: callback,
              options: options,
              value: value,
              title: text,
              renderTitleCallback: renderTitleCallback,
            ),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: position.makeRadius(),
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
                Text(
                  renderTitleCallback(value),
                  style: TextStyle(color: Color(0xFF909090), fontSize: 12),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
