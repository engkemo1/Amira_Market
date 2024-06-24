
import 'package:amira_market/view/sallary_screen/sallary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../constants.dart';
import '../view_model/logic/upload_logic.dart';
import 'add_file_screen.dart';
import 'attendance_screen/attendance_screen.dart';
import 'gift_card_screen/gift_card_screen.dart';
import 'login_screen.dart';
import 'notification_screen/add_notification.dart';
import 'order_screen/order_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, this.empCode});

  String? empCode;

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child:empCode!=null? User(empCode: empCode!,):Admin(),
          ),
        ),
      ),
    );
  }
}

class Admin extends StatelessWidget {
  const Admin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(
                "images/logo.jpg",
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "سلسلة سوبر ماركت اميره",
              style:
                  TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(height: 40,),
        const Text(
          "لوحة التحكم",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 80,),

        SizedBox(
          height: 55,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddNotificationScreen()));
              },
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(redLevelColor)),
              child: const Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.notification_add_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    Spacer(),
                    Text(
                      "اضافة اشعار",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 55,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>  AddFileScreen()));
              },
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(redLevelColor)),
              child: const Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.add_to_drive_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    Spacer(),
                    Text(
                      "اضافة ملف",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ),
Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          child: const Row(
            children: [
              Text(
                "تسجيل خروج ",
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Icon(
                Icons.logout,
                color: redLevelColor,
              )
            ],
          ),
        )
      ],
    );
  }
}
class User extends StatelessWidget {
  const User({
    super.key, required this.empCode,
  });
final String empCode;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(
                "images/logo.jpg",
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "سلسلة سوبر ماركت اميره",
              style:
              TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(height: 40,),
        const Text(
          "مرحباً بك",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 50,),

        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 55,
          child: ElevatedButton(
              onPressed: () async{
                try {
                  final value = await UploadController().downloadExcelFile("attendance.xlsx");
                  final items = UploadController().getEmpInfoItem(UploadController().readExcelFile(value, empCode));

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AttendanceScreen(
                    items: items,
                    fileName: 'الحضور',
                  )));
                } catch (e) {
                  print(e.toString());
                  await SmartDialog.showToast("هناك خطأ ملف الحضور غير موجود");
                }

              },
              style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(redLevelColor)),
              child: const Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.recommend_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    Spacer(),
                    Text(
                      "الحضور",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 55,
          child: ElevatedButton(
              onPressed: () async{
                try {
                  final value = await UploadController().downloadExcelFile("order.xlsx");
                  final items = UploadController().getEmpInfoItem(UploadController().readExcelFile(value, empCode));

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderScreen(
                    items: items,
                    fileName: 'الطلبات',
                  )));
                } catch (e) {
                  print(e.toString());
                  await SmartDialog.showToast("هناك خطأ ملف الطلبات  غير موجود");
                }

              },
              style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(redLevelColor)),
              child: const Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.recommend_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                    Spacer(),
                    Text(
                      "الطلبات",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 55,
          child: ElevatedButton(
              onPressed: () async{
                try {
                  final value = await UploadController().downloadExcelFile("data.xlsx");
                  final items = UploadController().getEmpInfoItem(UploadController().readExcelFile(value, empCode));

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => SallaryScreen(
                    items: items,
                    fileName: 'الرواتب',
                  )));
                } catch (e) {
                  print(e.toString());
                  await SmartDialog.showToast("هناك خطأ ملف الرواتب  غير موجود");
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(redLevelColor)),
              child: const Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.wallet,
                      color: Colors.white,
                      size: 25,
                    ),
                    Spacer(),
                    Text(
                      "الرواتب",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 55,
          child: ElevatedButton(
              onPressed: ()async
              {
                try {
                  final value = await UploadController().downloadExcelFile("giftcard.xlsx");
                  final items = UploadController().getEmpInfoItem(UploadController().readExcelFile(value, empCode));

                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => GiftCardScreen(
                    items: items,
                    fileName: 'بطاقات الهدايا',
                  )));
                } catch (e) {
                  print(e.toString());
                  await SmartDialog.showToast("هناك خطأ ملف بطاقات الهدايا غير موجود ");
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(redLevelColor)),
              child: const Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                      size: 25,
                    ),
                    Spacer(),
                    Text(
                      "بطاقات الهدايا",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    Spacer(),
                  ],
                ),
              )),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          child: const Row(
            children: [
              Text(
                "تسجيل خروج ",
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Icon(
                Icons.logout,
                color: redLevelColor,
              )
            ],
          ),
        )
      ],
    );
  }
}
