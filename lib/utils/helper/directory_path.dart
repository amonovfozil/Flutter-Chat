import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DirectoryPath {
  static Future<String> getPath() async {
    Directory? dir;
    dir = await getApplicationDocumentsDirectory();

    if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
    if (await dir.exists()) {
      return dir.path;
    } else {
      await dir.create(recursive: true);
      return dir.path;
    }
  }
}
