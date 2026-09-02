import 'package:flutter/widgets.dart';

/// Corner-radius scale taken from the prototype.
abstract final class AppRadii {
  static const double xs = 6;
  static const double sm = 10;
  static const double chip = 11;
  static const double tile = 12;
  static const double button = 13;
  static const double field = 14;
  static const double card = 16;
  static const double lg = 18;
  static const double sheet = 24;
  static const double device = 44;
  static const double pill = 999;

  static const rCard = BorderRadius.all(Radius.circular(card));
  static const rField = BorderRadius.all(Radius.circular(field));
  static const rButton = BorderRadius.all(Radius.circular(button));
  static const rChip = BorderRadius.all(Radius.circular(chip));
  static const rTile = BorderRadius.all(Radius.circular(tile));
  static const rLg = BorderRadius.all(Radius.circular(lg));
  static const rPill = BorderRadius.all(Radius.circular(pill));

  /// Bottom sheets round only their top corners.
  static const rSheet = BorderRadius.vertical(top: Radius.circular(sheet));
}
