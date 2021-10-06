import 'dart:async';

import 'package:camera/camera.dart';
import 'package:emedic/resources/recognize_controller.dart';
import 'package:emedic/resources/request_manager.dart';
import 'package:emedic/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as imglib;
import 'package:percent_indicator/linear_percent_indicator.dart';

class RecognizeFace extends StatefulWidget {
  final String documentId;
  final String doctorId;

  const RecognizeFace({Key key,@required this.documentId,@required this.doctorId}) : super(key: key);
  @override
  _RecognizeFaceState createState() => _RecognizeFaceState();
}

class _RecognizeFaceState extends State<RecognizeFace> {
  CameraController _cameraController;
  String _userId;
  bool _valid;
  int _count = 0;
  @override
  void initState() {
    super.initState();
    _valid = false;
    _count = 0;
    _getCamera();
  }
  void _getCamera()async {
    final user = await FirebaseAuth.instance.currentUser();
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _userId = user.uid;
      _startRecording();
      setState(() {});
    });
  }
  bool _uploading = false;

  void _startRecording()async{
    _cameraController.startImageStream((image){
      if(mounted) {
        RecognizeController recognizeController = RecognizeController();
        if(!_uploading){
          setState(() {
            _uploading = true;
          });
          if(_count >=3){
            print("validated");
            _cameraController.stopImageStream();
            RequestManager().grantAccess(widget.doctorId, widget.documentId);
          }
          _convertYUV420toImageColor(image).then((value) async {
            final result = await recognizeController.authenticate(value, _userId.toLowerCase());
            if(result){
              _count++;
            }
            if(mounted){
              setState(() {
                _valid = result;
                _uploading=false;
              });
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(_cameraController != null){
      return Scaffold(
        body: _count>=3?
            Column(
              children: [
                Spacer(flex: 3,),
                Container(
                  height: SizeConfig.blockSizeHorizontal *75,
                  child: FlareActor(
                    "assets/flare/lock.flr",
                    animation: "Unlock",
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeHorizontal*3,),
                Center(
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal * 45,
                    child: RaisedButton(
                      child: Text("Done",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *3.5)),
                      onPressed: ()=> Navigator.pop(context),
                    ),
                  ),
                ),  Spacer(flex: 3,),
              ],
            )
            :_buildRecordingWidget(context),
      );
    }
    return Scaffold(

    );
  }

  Column _buildRecordingWidget(BuildContext context) {
    return Column(
        children: [
          Spacer(flex: 3,),
          Text("Facial Recognition",style: GoogleFonts.gabriela(fontSize: SizeConfig.blockSizeHorizontal *5.5),),
          Spacer(flex: 1,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal *3),
            decoration: BoxDecoration(
              border: Border.all(color:_valid?Colors.green: Colors.red,width: 3)
            ),
            child: AspectRatio(
                aspectRatio:
                _cameraController.value.aspectRatio,
                child: CameraPreview(_cameraController)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal *2),
            child: LinearPercentIndicator(
              percent: (1/3)*_count,
              progressColor: Theme.of(context).primaryColor,
            ),
          ),
          Spacer(flex: 1,),
          Text("Please look straight into the camera",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *4)),
          Spacer(flex: 3,),
        ],
      );
  }
  final  shift = (0xFF << 24);
  Future<List<int>> _convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;

      var img = imglib.Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for(int x=0; x < width; x++) {
        for(int y=0; y < height; y++) {
          final int uvIndex = uvPixelStride * (x/2).floor() + uvRowStride*(y/2).floor();
          final int index = y * width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          final vp = image.planes[2].bytes[uvIndex];
          // Calculate pixel color
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          int g = (yp - up * 46549 / 131072 + 44 -vp * 93604 / 131072 + 91).round().clamp(0, 255);
          int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          img.data[index] = shift | (b << 16) | (g << 8) | r;
        }
      }

      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(img);
      return png;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

}
