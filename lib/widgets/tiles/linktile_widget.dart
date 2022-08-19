import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:neo/widgets/tiles/tile_position_enum.dart';

class LinkTile extends HookWidget {
  final String text;
  final Function callback;
  final TilePosition position;
  const LinkTile({
    required this.text,
    required this.callback,
    required this.position,
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
          callback();
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
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
