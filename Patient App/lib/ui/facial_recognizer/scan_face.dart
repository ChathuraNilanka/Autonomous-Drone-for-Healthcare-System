import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:emedic/models/upload_results.dart';
import 'package:emedic/resources/recognize_controller.dart';
import 'package:emedic/utils/size_config.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class ScanFace extends StatefulWidget {
  @override
  _ScanFaceState createState() => _ScanFaceState();
}

class _ScanFaceState extends State<ScanFace> {
  CameraController _cameraController;
  String _path;
  Timer _timer;
  int _currentSec = 10;
  _Status _scanStatus = _Status.NotStarted;
  RecognizeController _recognizeController = RecognizeController();
  String _fileName;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }
  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_currentSec < 1) {
            timer.cancel();
            _cameraController.stopVideoRecording().then((value) =>             _uploading());
          } else {
            _currentSec = _currentSec - 1;
          }
        },
      ),
    );
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:WillPopScope(
        onWillPop: ()async{
          return false;
        },
          child: _buildBody()),
    );
  }
  void _startRecording()async{
    await _cameraController.startVideoRecording(_path);
    _startTimer();
    setState(() {
      _scanStatus = _Status.Recording;
    });
  }
  void _uploading()async{
    setState(() {
      _scanStatus = _Status.Uploading;
    });
    final result = await _recognizeController.uploadVideo(_path,_fileName);
    if(result != null){
      _collecting(result);
    }else{
      print("upload result is null");
    }
  }

  void _collecting(UploadResult result)async{
    setState(() {
      _scanStatus = _Status.Collecting;
    });
    final collected = await _recognizeController.collectImages(result);
    setState(() {
      _scanStatus = _Status.Success;
    });
    if(collected)
      await _recognizeController.trainModel();
  }

  Widget _notStarted(){
    final radius =BorderRadius.circular(40);
    return Column(
      children: [
        Spacer(flex: 3,),
        Text("Facial Recognition",style: GoogleFonts.gabriela(fontSize: SizeConfig.blockSizeHorizontal *5.5),),
        Spacer(flex: 1,),
        Container(
          alignment: Alignment.center,
          child: Container(
            width: SizeConfig.blockSizeHorizontal*70,
            child: Material(
              borderRadius: radius,
              elevation: 5,
                child: ClipRRect(
                    borderRadius: radius,
                    child: Image.asset("assets/images/facial-recognition.png"))),
          ),
        ),
        Spacer(flex: 1,),
        Text("Use Artificial Intelligence (AI) to guard your privacy.",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *4),),
        SizedBox(height: SizeConfig.blockSizeHorizontal*3,),
        Center(
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 45,
            child: RaisedButton(
              child: Text("Let's start",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *3.5)),
              onPressed: ()=> _startRecording(),
            ),
          ),
        ),
        Spacer(flex: 3,),
      ],
    );
  }
  Widget _uploadingWidget(){
    return Column(
      children: [
        Spacer(flex: 3,),
        Container(
          height: SizeConfig.blockSizeHorizontal *75,
          child: FlareActor(
            "assets/flare/analysis.flr",
            animation: "analysis",
          ),
        ),
        Center(child: Text("Sending the data to secure server...",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *4),)),
        Spacer(flex: 3,),
      ],
    );
  }
  Widget _collectingWidget(){
    return Column(
      children: [
        Spacer(flex: 3,),
        Container(
          height: SizeConfig.blockSizeHorizontal *75,
          child: FlareActor(
            "assets/flare/analysis.flr",
            animation: "analysis",
          ),
        ),
        Center(child: Text("Securing your account...",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *4),)),
        Spacer(flex: 3,),      ],
    );
  }

  Widget _successWidget(){
    return Column(
      children: [
        Spacer(flex: 3,),
        Container(
          height: SizeConfig.blockSizeHorizontal *75,
          child: FlareActor(
            "assets/flare/lock.flr",
            animation: "Lock",
          ),
        ),
        Center(child: Text("Your account will be activated within 24 hours",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *4),)),
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
    );
  }
  Widget _recordingWidget(){
    return Column(
      children: [
        Spacer(flex: 3,),
        Text("Facial Recognition",style: GoogleFonts.gabriela(fontSize: SizeConfig.blockSizeHorizontal *5.5),),
        Spacer(flex: 1,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal *3),
          child: AspectRatio(
    aspectRatio:
    _cameraController.value.aspectRatio,
          child: CameraPreview(_cameraController)),
        ),
        Spacer(flex: 1,),
        Text("Please look straight into the camera",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *4)),
        Text("$_currentSec seconds",style: GoogleFonts.roboto(fontSize: SizeConfig.blockSizeHorizontal *4,color: Colors.green,fontWeight: FontWeight.bold)),
        Spacer(flex: 3,),
      ],
    );
  }


  Widget _buildBody(){
    Widget child = Container();
    switch (_scanStatus){
      case _Status.NotStarted:
        child =  _notStarted();
        break;
        case _Status.Recording:
          child = _recordingWidget();
          break;
      case _Status.Uploading:
        child = _uploadingWidget();
        break;
      case _Status.Collecting:
        child = _collectingWidget();
        break;
      case _Status.Success:
        child = _successWidget();
        break;
    }
    return child;

  }

  void _initCamera() async{
    Directory tempDir = await getExternalStorageDirectory();
    final myPath = "${tempDir.path}/recognizer";
    await Directory(myPath).create(recursive: true);
    final fileName = "${DateTime.now().millisecondsSinceEpoch}.mp4";
    final cameras = await availableCameras();

    setState(() {
      _fileName = fileName;
      _path = "$myPath/$fileName";
    });
    _cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
}
enum _Status{
  NotStarted,Recording,Uploading,Collecting,Success
}