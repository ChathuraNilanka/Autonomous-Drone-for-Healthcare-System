import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/utils/my_alert_dialog.dart';
import 'package:emedic/models/user.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/themes.dart';
import 'package:emedic/utils/widgets/app_scaffold.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CameraUpload extends StatefulWidget {
  @override
  _CameraUploadState createState() => _CameraUploadState();
}

class _CameraUploadState extends State<CameraUpload> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://e-medic-db912.appspot.com');
  File _image;
  ImageSource _imageSource = ImageSource.camera;
//  StorageUploadTask _uploadTask;
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: _imageSource);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      setState(() {
        _image = croppedFile;
      });
      showDialog(
          context: context,
          child: MyAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      child: SpinKitDualRing(
                        color: Theme.of(context).primaryColor,
                        size: 15,
                        lineWidth: 3,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Please wait"),
                  ],
                ),
              ],
            ),
          ));
      await _upload();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      body: AppScaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _scaffoldGlobalKey.currentState
                  .showBottomSheet((context) => StatefulBuilder(
                        builder: (context, setState) => _bottomWidget(),
                      ));
            },
            child: Icon(Icons.add),
          ),
          page: DrawerPages.cameraUpload,
          child: Container(
            color: backgroundColor,
            child: Column(
              children: <Widget>[Expanded(child: _prescriptionList())],
            ),
          )),
    );
  }

  Widget _prescriptionList() {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection("uploadPrescription")
            .where("userID", isEqualTo: User().id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Container();
          final documents = snapshot.data.documents;
          if (documents.length == 0) return Container();
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data;
              final time = data["createdAt"] ?? Timestamp.now();
              final path = data["path"] ?? "idk";
              final status = data["status"];
              final id = documents[index].documentID;
              return Container(
                height: 80,
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: FutureBuilder(
                              future:
                                  _storage.ref().child(path).getDownloadURL(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return LoadingWidget(
                                    size: 10,
                                  );
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot.data,
                                    placeholder: (context, _) => LoadingWidget(
                                      size: 10,
                                    ),
                                    errorWidget: (context, _, a) {
                                      return Icon(Icons.broken_image);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(id),
                              SizedBox(
                                height: 2,
                              ),
                              Text(DateFormat("MMM dd, yyyy hh:mm")
                                  .format(time.toDate())),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Status: ${status ?? "Received"}",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _bottomWidget() {
    final radius = Radius.circular(35);
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.13,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _bottomRowIcon(
                  UploadPrescriptionPageText.camera, FontAwesomeIcons.camera,
                  () {
                setState(() {
                  _imageSource = ImageSource.camera;
                });
                _getImage();
              }),
            ),
            Expanded(
              child: _bottomRowIcon(
                  UploadPrescriptionPageText.gallery, FontAwesomeIcons.images,
                  () {
                setState(() {
                  _imageSource = ImageSource.gallery;
                });
                _getImage();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomRowIcon(String title, IconData icon, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon),
            Text(title),
          ],
        ),
      ),
    );
  }

  Future<void> _upload() async {
    Repository _repo = Repository();

    DateTime now = DateTime.now();
    FirebaseUser user = await _repo.getCurrentFirebaseUser();
    String uid = user.uid;
    String path =
        'prescriptions/handwritten/${DateFormat("DDMMyyyyy_HHmmss").format(now)}_$uid.png';
    await _repo.updatePrescriptionCollection(now, path, uid);
    setState(() {
//      _uploadTask = _storage.ref().child(path).putFile(_image);
    });
  }
}
