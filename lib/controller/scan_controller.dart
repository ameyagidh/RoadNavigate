import 'package:camera/camera.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:flutter_tflite/flutter_tflite.dart";

class ScanController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;

  late List<CameraDescription> cameras;
  var cameraCount = 0;
  var x,y,w,h = 0.0;
  var label = "";
  var isCameraInitialized = false.obs;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = await CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      await cameraController.initialize().then((value){
        cameraController.startImageStream((image){
          cameraCount +=1 ;
          if(cameraCount % 10 == 0){
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
        
      });
      isCameraInitialized(true);
      update();
    } else {
      print("Permission Denied");
    }
  }

  initTFLite() async{
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDetector(CameraImage image) async{
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e){
          return e.bytes;
        }).toList(),
        asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );
    if(detector != null){
      var objectDetected = detector.first;
      // if (objectDetected["confidenceInClass"] != null &&
      //     objectDetected["confidenceInClass"] * 100 > 0)  {
        print("object detected is $detector");
        label = detector.first["detectedClass"].toString();
        print(label);
        h = objectDetected['rect']["h"];
        w = objectDetected['rect']["w"];
        x = objectDetected['rect']["x"];
        y = objectDetected['rect']["y"];
      // }
      update();
    }
  }
}
