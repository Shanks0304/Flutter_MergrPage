import 'dart:io';
import 'dart:math';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FFmpeg {
  static Future<File> concatenate(
      List<String> assetPaths, Function(File? file) onSuccess) async {
    // FFmpegKitConfig.enableLogCallback((logCallback) {
    //   print(logCallback.getMessage());
    // });
    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/SavedRecording.wav");

    final cmd = ["-y"];
    for (var path in assetPaths) {
      //final tmp = await copyToTemp(path);
      cmd.add("-i");
      cmd.add(path);
    }

    cmd.addAll([
      "-filter_complex",
      "[0:a] [1:a] amix=inputs=2:duration=longest:dropout_transition=2",
      file.path
    ]);

    await FFmpegKit.executeWithArgumentsAsync(cmd, (session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        debugPrint('File saved at 02 - ${file.path}');
        onSuccess(file);
        debugPrint('Audio loaded');
      } else if (ReturnCode.isCancel(returnCode)) {
        //cancelled
      } else {
        debugPrint(returnCode.toString());
        session.getAllLogsAsString().then((result) {
          print(result);
        });
      }
    });
    if (await file.exists()) {
      debugPrint('File saved at 01 - ${file.path}');
      return file;
    } else {
      debugPrint('Unable to save file ${file.path}');
      return file;
    }
  }

  static Future<File> copyToTemp(String file) async {
    Directory? tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp${getRandom(5)}.m4a');
    final source = File(file);
    await source.copy(tempFile.path);
    return tempFile;
  }

  static String getRandom(int length) {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random r = Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }
}
