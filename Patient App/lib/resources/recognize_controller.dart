import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:emedic/models/upload_results.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/resources/user_provider.dart';
import 'package:emedic/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class RecognizeController{
  final _backend = Common.facialServer;
  Dio _dio = Dio();
  Future<UploadResult> uploadVideo(String path,String fileName) async {
    FormData formData = FormData.fromMap({
      "video":
      MultipartFile.fromFileSync(
          path, filename:fileName),
    });
    final response = await _dio.post("$_backend/videos",data: formData);
    print(response.data);
    if(response.statusCode == 201)
      return UploadResult.fromJson(response.data);
    else
      _showToast(response.data["error"]);
      return null;
  }
  Future<bool> collectImages(UploadResult result) async {
    print("called");
    final user =await Repository().getCurrentFirebaseUser();
    FormData formData = FormData.fromMap({
      "video_name": result.name,
      "id":user.uid.toLowerCase(),
    });
    final response = await _dio.post("$_backend/collect_images",data: formData);
    print(response.data);
    if(response.statusCode == 200)
      return true;
    else
      _showToast(response.data["error"]);
    return false;
  }
  Future<void> trainModel() async {
    _showToast("Your account will activate within 24 hours");
    final user =await Repository().getCurrentFirebaseUser();
    UserProvider().updateAuthentication(user.uid);
    FormData formData = FormData.fromMap({
      "id":user.uid.toLowerCase(),
    });
    final response = await _dio.post("$_backend/train_model",data: formData);
    if(response.statusCode>=200 && response.statusCode <=203){
    }
  }
  Future<void> _writeToFile(Uint8List data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  Future<bool> authenticate(Uint8List image,String uid) async {
    Directory tempDir = await getExternalStorageDirectory();
    final myPath = "${tempDir.path}/images";
    await Directory(myPath).create(recursive: true);
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.png";
    final path = "$myPath/$fileName";
    await _writeToFile(image, path);

    FormData formData = FormData.fromMap({
      "image":
      await MultipartFile.fromFile(path),
      "id":uid
    });


    final response = await _dio.post("$_backend/recognize",data: formData,          options: Options(
      followRedirects: false,
      validateStatus: (status) {
        return status < 500;
      },
    ),);
    File(path).deleteSync(recursive: true);
    return response.data["success"].toString() == "1";
  }

  _showToast(String text){
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.black,
          fontSize: 12.0
      );
  }

}