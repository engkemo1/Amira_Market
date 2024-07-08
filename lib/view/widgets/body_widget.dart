import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../model/emp_info_item.dart';

class BodyWidget extends StatelessWidget {
  BodyWidget({super.key, required this.items, required this.fileName});

  final String fileName;
  final List<EmpInfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 70,
          color: redLevelColor,
          child: ListTile(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            trailing: const Padding(
              padding: EdgeInsets.all(2.0),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("images/logo.png"),
              ),
            ),
            title: Text(
              fileName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Table(
                  textDirection: TextDirection.rtl,
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  children: [
                    for (var item in items)
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.title,
                                    style: TextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.value,
                                  style: TextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
