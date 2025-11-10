import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

String rgbToHex(Color color) {
  // Handle both integer (0–255) and float (0.0–1.0) channels safely
  double r = color.red is double ? color.red * 255 : color.red.toDouble();
  double g = color.green is double ? color.green * 255 : color.green.toDouble();
  double b = color.blue is double ? color.blue * 255 : color.blue.toDouble();

  int ri = r.round().clamp(0, 255);
  int gi = g.round().clamp(0, 255);
  int bi = b.round().clamp(0, 255);

  return '${ri.toRadixString(16).padLeft(2, '0')}'
          '${gi.toRadixString(16).padLeft(2, '0')}'
          '${bi.toRadixString(16).padLeft(2, '0')}'
      .toUpperCase();
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickAudio() async {
  try {
    final filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (filePickerResult != null) {
      return File(filePickerResult.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (filePickerResult != null) {
      return File(filePickerResult.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
