import 'dart:developer';
import 'dart:io' show HttpClient, File;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert' show utf8;

import 'model/cache_base_model.dart';

/// This service searches for a file in the cache from the given URL, and returns it if it exists.
///
/// If the file does not exist in the cache, it downloads it, saves it, and returns it.
///
/// This way, the existence of the file can be checked in the cache first, and downloaded if it is not there.
///
/// Separating the cache mechanism into a separate class improves the readability of the code.
///
/// E.g:
/// ```dart
/// final cacheService = CacheService();
///  final file = await cacheService.getOrDownloadFile('http://example.com/file.mp3', 'file.mp3');
///```

class CacheService {
  static final CacheService _singleton = CacheService._internal();

  factory CacheService() {
    return _singleton;
  }

  CacheService._internal();

  Future<CacheBaseModel> getOrDownloadFile(String url, String fileName, [bool? cacheEnabled, bool? isFile]) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);

      if (await file.exists()) {
        return CacheBaseModel(status: true, file: file);
      } else {
        final httpClient = HttpClient();
        final request = await httpClient.getUrl(Uri.parse(url));
        if (cacheEnabled == null || cacheEnabled) {
          final response = await request.close();
          final bytes = await consolidateHttpClientResponseBytes(response);
          await file.writeAsBytes(bytes);

          return CacheBaseModel(status: true, file: file);
        } else {
          final response = await request.close();
          if (isFile == null || !isFile) {
            final body = await response.transform(utf8.decoder).join();

            return CacheBaseModel(status: false, file: body);
          } else {
            final bytes = await consolidateHttpClientResponseBytes(response);
            await file.writeAsBytes(bytes);

            return CacheBaseModel(status: true, file: file);
          }
        }
      }
    } catch (e) {
      log('[CacheService]  $e');
      rethrow;
    }
  }

  /// This method is getting a file from the cache.
  Future<File> getFileFromLocale(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    return file;
  }

  /// This method is checking if a file exists in the cache.
  Future<bool> isFileExist(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    return await file.exists();
  }

  /// This method is deleting a file from the cache.
  Future<void> deleteFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    await file.delete();
  }

  /// This method is deleting all files from the cache.
  Future<void> deleteAllFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    for (final file in files) {
      await file.delete();
    }
  }
}
