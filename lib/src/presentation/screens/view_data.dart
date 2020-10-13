import 'package:boong_task/src/helpers/read_data.dart';
import 'package:flutter/material.dart';

class ViewDataScreen extends StatelessWidget {
  static const routename = "/view";
  DataRow buildDataRow(List<String> data) {
    print("from buildDataRow");
    print(data);
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

  buildDataColumns() {
    List columns = <DataColumn>[
      DataColumn(
        label: Text(
          'Name',
        ),
      ),
      DataColumn(
        label: Text(
          'Age',
        ),
      ),
      DataColumn(
        label: Text(
          'Father\'s Name',
        ),
      ),
      DataColumn(
        label: Text(
          'Phone',
        ),
      ),
      DataColumn(
        label: Text(
          'Aadhar Card',
        ),
      ),
      DataColumn(
        label: Text(
          'Address',
        ),
      ),
      DataColumn(
        label: Text(
          'Caste',
        ),
      ),
      DataColumn(
        label: Text(
          'Subcaste',
        ),
      ),
      DataColumn(
        label: Text(
          'Annual Income',
        ),
      ),
      DataColumn(
        label: Text(
          'Origin Date',
        ),
      ),
      DataColumn(
        label: Text(
          'Origin Village',
        ),
      ),
      DataColumn(
        label: Text(
          'Origin District',
        ),
      ),
      DataColumn(
        label: Text(
          'Destination Date',
        ),
      ),
      DataColumn(
        label: Text(
          'Destination Village',
        ),
      ),
      DataColumn(
        label: Text(
          'Destination District',
        ),
      ),
      DataColumn(
        label: Text(
          'Report Date',
        ),
      ),
      DataColumn(
        label: Text(
          'Wife Name',
        ),
      ),
      DataColumn(
        label: Text(
          'Wife Age',
        ),
      ),
      DataColumn(
        label: Text(
          'Number of Sons',
        ),
      ),
      DataColumn(
        label: Text(
          'Names',
        ),
      ),
      DataColumn(
        label: Text(
          'Ages',
        ),
      ),
      DataColumn(
        label: Text(
          'Number of Daughters',
        ),
      ),
      DataColumn(
        label: Text(
          'Names',
        ),
      ),
      DataColumn(
        label: Text(
          'Ages',
        ),
      ),
      DataColumn(
        label: Text(
          'Goats',
        ),
      ),
      DataColumn(
        label: Text(
          'Sheep',
        ),
      ),
      DataColumn(
        label: Text(
          'Cow',
        ),
      ),
      DataColumn(
        label: Text(
          'Bull',
        ),
      ),
      DataColumn(
        label: Text(
          'Buffaloes',
        ),
      ),
    ];
    print("columns");
    print(columns.length);
    return columns;
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
          print(snapshot.data.length);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(rows: <DataRow>[
              for (int i = 0; i < snapshot.data.length; i++) buildDataRow(snapshot.data[i]),
            ], columns: buildDataColumns()),
          );
        },
      ),
    );
  }
}
