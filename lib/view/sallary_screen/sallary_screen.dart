import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../model/emp_info_item.dart';
import '../widgets/body_widget.dart';

class SallaryScreen extends StatelessWidget {
   const SallaryScreen({super.key,  required this.fileName, required this.items});
  final String fileName;
  final List<EmpInfoItem> items;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: BodyWidget(items: items,fileName:fileName ,),
    );
  }
}
