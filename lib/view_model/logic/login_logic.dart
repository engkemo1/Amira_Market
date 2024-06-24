import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart'; // Import the collection package
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excel/excel.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/credentials.dart';
import '../../view/home_screen.dart';
import '../local.dart';

class  LoginLogic {
  Future<String> _downloadExcelFile() async {
    String myFile = "username.xlsx";

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(myFile);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/$myFile';

    File downloadToFile = File(filePath);
    await ref.writeToFile(downloadToFile);

    return filePath;
  }

  Future<List<EmpCredentials>> _readExcelFile(String filePath) async {
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<EmpCredentials> empCredentials = [];

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table]!.maxCols);
      print(excel.tables[table]!.maxRows);

      print(excel.tables[table]!.rows.first);

      for (var row in excel.tables[table]!.rows) {
        if (row[0] == null || row[1] == null) {
          continue;
        }

        empCredentials.add(EmpCredentials(
            empCode: row[0]!.value.toString(),
            password: row[1]!.value.toString()));
      }
    }

    return empCredentials;
  }

  void showCustomDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 300.0, // Set the width of the dialog
            height: 400.0, // Set the height of the dialog
            child: Text(msg),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('حسنا'),
            ),
          ],
        );
      },
    );
  }

  void login(String empCode, String empPass, BuildContext context) async {
SmartDialog.showLoading();
    if (empCode == "1245" && empPass == "123456") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>   HomeScreen()), (_) => false);
      SmartDialog.dismiss();
    }else{
      await _readExcelFile(await _downloadExcelFile()).then((value){
        var i = value.firstWhereOrNull((e) => empCode == e.empCode && e.password == empPass);
        if (i != null) {
          CacheHelper.put(key: "currentUserKey", value: i.empCode);
          FirebaseMessaging.instance.getToken().then((token) {
            FirebaseFirestore.instance.collection("users").doc(i.empCode).set(
                {
                  "empCode":i.empCode,
                  "token":token
                });
          });

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                empCode: empCode,
              ),
            ),
                (_) => false,
          );
          SmartDialog.showToast("تم التسجيل بنجاح");

          SmartDialog.dismiss();
        } else {
          SmartDialog.showToast("خطا في كود الموظف أو الباسورد");
          SmartDialog.dismiss();
        }






      });

    }







  }

}
