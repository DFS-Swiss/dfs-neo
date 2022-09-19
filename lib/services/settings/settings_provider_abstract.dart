import 'package:flutter/material.dart';

abstract class SettingsProvider<T> extends ChangeNotifier {
  SettingsProvider(T? fromStorage) {
    if (fromStorage != null) {
      setValue(fromStorage);
    }
  }

  T getValue();
  setValue(T value);
}
