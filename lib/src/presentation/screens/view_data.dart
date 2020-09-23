import 'package:boong_task/src/helpers/read_data.dart';
import 'package:flutter/material.dart';

class ViewDataScreen extends StatelessWidget {
  static const routename = "/view";
  DataRow buildDataRow(List<String> data) {
    return DataRow(
      cells: data
          .map<DataCell>(
            (cell) => DataCell(
              Text(cell),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Data"),
      ),
      body: FutureBuilder<List<List<String>>>(
        future: readDataFromCSV(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              rows: <DataRow>[
                for (int i = 0; i < snapshot.data.length; i++) buildDataRow(snapshot.data[i]),
              ],
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Name',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Aadhar Number',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Monthly Income',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Father\'s Name',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'No. of Family Members',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Address',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Origin',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Destination',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Route',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Livestock(max)',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
