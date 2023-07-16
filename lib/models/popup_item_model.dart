import 'package:flutter/material.dart';

class ItemContent {
  String? value;
  String? label;
  IconData? icon;
  bool enabled;

  ItemContent({this.value, this.label, this.icon, this.enabled = true});
}
