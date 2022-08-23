//@dart = 2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ImageUploader {
  final String _url;

  ImageUploader(this._url);

  Future<String> uploadImage(File image) async {
    final request = MultipartRequest('POST', Uri.parse(_url));
    request.files.add(await MultipartFile.fromPath('picture', image.path));
    final result = await request.send(); //StreamedRespose result
    if (result.statusCode != 200) return null;
    final respose = await Response.fromStream(result);
    debugPrint(Uri.parse(_url).origin + respose.body);
    return (Uri.parse(_url).origin + respose.body);
  }
}
