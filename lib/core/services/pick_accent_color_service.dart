import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PickAccentColor {

  static PickAccentColor instance = new PickAccentColor();

  Future<Color> getAccentColor(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator?.lightVibrantColor?.color??paletteGenerator?.dominantColor?.color;
  }
}
