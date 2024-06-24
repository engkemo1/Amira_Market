import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../view_model/logic/upload_logic.dart';

class AddFileScreen extends StatelessWidget {
  AddFileScreen({
    super.key,
  });

  final UploadController uploadController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 100),
          child: GetBuilder<UploadController>(builder: (controller) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(
                          "images/logo.jpg",
                        ),
                      ),
                      const Text(
                        "اضافة ملف حضور",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ));
          }),
        ),
        body: Center(
            child: SizedBox(
                width: 200,
                height: 55,
                child: ElevatedButton(
                    onPressed: () {
                      uploadController.pickFilesAndUpload(() {
                        if (uploadController.pickedFilesLength ==
                            uploadController.failedUpload.length) {
                          SmartDialog.showToast("فشل رفع جميع الملفات");
                        } else if (uploadController.failedUpload.isEmpty) {

                          SmartDialog.showToast("تم رفع جميع الملفات بنجاح");
                        } else {
                          uploadController
                              .showFailedFilesUploadCustomDialog(context);
                        }
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all(redLevelColor)),
                    child: const Text(
                      "اضافة ملف",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    )))));
  }
}
