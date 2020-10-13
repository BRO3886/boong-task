import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<List<String>>> readDataFromCSV() async {
  if (await Permission.storage.request().isGranted) {
    String dir = (await getExternalStorageDirectory()).path;
    print(dir);
    try {
      String fContent = File(dir + "/data.csv").readAsStringSync();
      List<String> rows = fContent.split("\n");
      rows.removeLast();
      print(rows);
      List<List<String>> data = new List<List<String>>();
      for (var row in rows) {
        List<String> col = row.split(",");
        data.add(col);
      }
      print(data);
      return data;
    } catch (e) {
      print(e.toString());
    }
  }
}
