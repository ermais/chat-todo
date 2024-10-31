import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<File>> pickMultipleImages(BuildContext context) async {
  Map<Permission, PermissionStatus> _permissions =
      await [Permission.storage, Permission.photos].request();

  var status = await Permission.photos.request();

  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);
  if (status.isGranted) {
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
      return [];
    }
  } else if (status.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Storage permission is required to pick images.")),
    );
    return [];
  }
  return [];
}
