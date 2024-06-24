import 'package:amira_market/view/login_screen.dart';
import 'package:amira_market/view_model/local.dart';
import 'package:amira_market/view_model/logic/local_notification.dart';
import 'package:amira_market/view_model/logic/notification.dart';
import 'package:amira_market/view_model/logic/upload_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
// ..
  CacheHelper.init();
  NotificationLogic().initialize();
  NotificationService().onInit();
  await CacheHelper.init();
  runApp(const MyApp());
}







class MyApp extends StatelessWidget {


  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(UploadController()); // Initialize your controller

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
    );
  }
}
