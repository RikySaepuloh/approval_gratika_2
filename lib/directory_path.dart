import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryPath{
  getPath() async {
    final Directory? tempDir = await getExternalStorageDirectory();
    final filePath = Directory("${tempDir!.path}/files");
    if(await filePath.exists()){
      return filePath.path;
    }else{
      filePath.create(recursive: true);
      return filePath.path;
    }

    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    final Directory? downloadsDir = await getDownloadsDirectory();
  }
}