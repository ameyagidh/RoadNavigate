import 'package:camera/camera.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;
  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = await CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      await cameraController.initialize();
      isCameraInitialized(true);
      update();
    } else {
      print("Permission Denied");
    }
  }
}
