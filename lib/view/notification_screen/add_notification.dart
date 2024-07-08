import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../view_model/logic/notification.dart';

class AddNotificationScreen extends StatefulWidget {
  const AddNotificationScreen({super.key});

  @override
  State<AddNotificationScreen> createState() => _AddNotificationScreenState();
}

class _AddNotificationScreenState extends State<AddNotificationScreen> {
  int _groupValue = 3;
  TextEditingController bodyController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  TextEditingController codeController = TextEditingController();
  var department;
  List<String> departmentList = ["AB", "VD", "DA"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.black,
                    backgroundImage: AssetImage(
                      "images/logo.png",
                    ),
                  ),
                  const Text(
                    "اضافة اشعار",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
            )),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Column(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: _groupValue,
                        onChanged: (int? value) {
                          setState(() {
                            _groupValue = value!;
                          });
                        },
                      ),
                      const Text('موظف',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  )),
                  Flexible(
                      child: Column(
                    children: [
                      Radio<int>(
                        value: 2,
                        groupValue: _groupValue,
                        onChanged: (int? value) {
                          setState(() {
                            _groupValue = value!;
                          });
                        },
                      ),
                      const Text('قسم',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  )),
                  Flexible(
                    child: Column(
                      children: [
                        Radio<int>(
                          value: 3,
                          groupValue: _groupValue,
                          onChanged: (int? value) {
                            setState(() {
                              _groupValue = value!;
                            });
                          },
                        ),
                        const Text('الكل',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _groupValue == 1
                  ? TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.black)),
                          label: Text("كود الموظف"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    )
                  : _groupValue == 2
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: DropdownButton<dynamic>(
                              hint: const Text("اختار القسم"),
                              underline: SizedBox(),
                              isExpanded: true,
                              value: department,
                              items: departmentList
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                department = value;
                                setState(() {});
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black)),
                    label: Text("عنوان"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: bodyController,
                maxLines: 5,
                decoration: InputDecoration(
                    label: const Text("الاشعار"),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                    onPressed: () async{
                      if (_groupValue == 1) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .get()
                            .then((value) {
                          var i = value.docs.firstWhereOrNull((e) =>
                              codeController.text == e.data()["empCode"]);
                          if (i != null) {
                            NotificationLogic().sendNotification(
                                i.data()["token"],
                                titleController.text,
                                bodyController.text);
                          }else{
                            SmartDialog.showToast("لا يوجد كود موظف بهذا الرقم");
                          }
                        });
                      } else {
                       await NotificationLogic().sendNotificationToAllUsers(
                            titleController.text, bodyController.text);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(redLevelColor)),
                    child: const Center(
                      child: Text(
                        "إرسال",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
