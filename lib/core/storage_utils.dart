import 'dart:convert';
import 'dart:io';

import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart';
import 'package:project_runway/features/vision_boards/presentation/pages/edit_vision_detaiils/edit_vision_details.dart';

class StorageUtils {
  static Future<String> uploadFile(
    String path,
    String visionBoardId,
    VisionUploadProviderModel uploadState,
  ) async {
    // create the file object
    final fileData = File(path);

    final uploader = FlutterUploader();
    final taskId = await uploader.enqueue(
      url: "https://api.imgur.com/3/upload",
      headers: {
        "Authorization": "Client-ID 01f538703d3d618",
        "content-type": "application/json",
      },
      data: {
        "type": "file",
        "title": "vision board image",
        "description": "one of the visions in the vision board",
      },
      files: [
        FileItem(
            savedDir: dirname(fileData.path),
            filename: basename(fileData.path),
            fieldname: "image")
      ],
      showNotification: true,
      method: UploadMethod.POST,
    );

    uploader.progress.listen((event) {
      uploadState.assignProgress(event.progress);
    });

    uploader.result.listen((event) {
      if (event.status == UploadTaskStatus.complete) {
        Map<String, Object> response = json.decode(event.response);
        Map<String, Object> data = response["data"];
        String link = data["link"];
        uploadState.assignResponse(link);
      }
    });

    return taskId;
  }
}
