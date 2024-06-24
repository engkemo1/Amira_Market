import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excel/excel.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/emp_info_item.dart';
import '../../model/file_info.dart';

class UploadController extends GetxController {
  List<FileInfo> failedUpload = [];
  int pickedFilesLength = 0;






  Future<String> downloadExcelFile(String myFile) async {

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(myFile);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$myFile';

    File downloadToFile = File(filePath);
    await ref.writeToFile(downloadToFile);

    return filePath;

  }

  List readExcelFile(String filePath,String empCode){

    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List loggedEmpInfo = [];

    for (var table in excel.tables.keys) {

      print(table); //sheet Name
      print(excel.tables[table]!.maxCols);
      print(excel.tables[table]!.maxRows);

      print(excel.tables[table]!.rows.first);

      for (var row in excel.tables[table]!.rows) {

        if(row[0] == null || row[1] == null){
          continue;
        }

        try{

          var condition = (double.tryParse(row[0]!.value.toString())?.truncate()).toString() == empCode;
          if(condition){

            loggedEmpInfo.add(excel.tables[table]!.rows.first);
            loggedEmpInfo.add(row);
            return loggedEmpInfo;
          }

        }catch(e){
          print(e);
        }

      }
    }

    return loggedEmpInfo;
  }

  List<EmpInfoItem> getEmpInfoItem(List loggedEmpInfo){

    List<EmpInfoItem> empInfoItemList = [];

    if(loggedEmpInfo.isNotEmpty){

      for(int index = 0; index <loggedEmpInfo[0].length;index++){

        var empInfoItem = EmpInfoItem(title:loggedEmpInfo[0][index].value.toString(),value:loggedEmpInfo[1][index].value.toString());
        empInfoItemList.add(empInfoItem);
      }

    }

    return empInfoItemList;
  }

  Future<void> pickFilesAndUpload(Function completion) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      List<PlatformFile> files = result.files;
      pickedFilesLength = files.length;

      for (int i = 0; i < files.length; i++) {
        print('File name: ${files[i].name}');
        print('File size: ${files[i].size}');
        print('File path: ${files[i].path}');

        if (i == (files.length) - 1) {
          uploadFileToFirebase(files[i], completion: completion);
        }
      }
    } else {}
  }

  Future<void> uploadFileToFirebase(PlatformFile file,
      {Function? completion}) async {
    SmartDialog.showLoading();
    if (file.path == null) return;

    File fileToUpload = File(file.path!);
    final storageRef = FirebaseStorage.instance.ref().child('${file.name}');

    try {
      await storageRef.getDownloadURL();
      await storageRef.delete();

      print('File deleted successfully');

    } catch (e) {

      if (e is FirebaseException && e.code == 'object-not-found') {
        print('File does not exist. Ready to add the file...');
      } else {
        print('Failed to check file existence: $e');
        return;
      }
    }

    try {
      await storageRef.putFile(fileToUpload);

      String downloadURL = await storageRef.getDownloadURL();
      print('Download URL: $downloadURL');
       SmartDialog.dismiss();

      if (completion != null) {

        completion();
      }
    } catch (e) {
      print('Error occurred while uploading file: $e');

      failedUpload.add(FileInfo(
          name: '${file.name}',
          uploaded: false,
          msg: "لم يتم رفع الملف بنجاح"));
       SmartDialog.dismiss();

      if (completion != null) {
        completion();
      }
    }
  }

  void showFailedFilesUploadCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تم رفع الملفات ما عدا الآتي :'),
          content: const SizedBox(
            width: 300.0, // Set the width of the dialog
            height: 400.0, // Set the height of the dialog
            // child: MyListView(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
