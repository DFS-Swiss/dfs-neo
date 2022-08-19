import 'package:flutter/material.dart';

enum TilePosition { top, bottom, middle, standalone }

extension TilePositionExt on TilePosition {
  BorderRadius makeRadius() {
    switch (this) {
      case TilePosition.standalone:
        return BorderRadius.circular(12);
      case TilePosition.top:
        return BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        );
      case TilePosition.bottom:
        return BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        );
      case TilePosition.middle:
        return BorderRadius.circular(0);
    }
  }
}
