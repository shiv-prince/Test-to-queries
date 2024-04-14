import 'package:flutter/material.dart';

class DynamicTableWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  DynamicTableWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    // Extract data from the response
    Map<String, dynamic> rowData = data['data'] ?? {};
    List<String> columns = rowData.keys.toList();

    // Build the table widget
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Table'),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        interactive: true,
        thickness: 20,
        scrollbarOrientation: ScrollbarOrientation.left,
        radius: const Radius.circular(20),
        child: Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          thickness: 10,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          radius: const Radius.circular(20),
          child: SingleChildScrollView(
            physics:
                const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: _buildColumns(columns),
                rows: _buildRows(rowData, columns),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(List<String> columns) {
    return columns.map((column) => DataColumn(label: Text(column))).toList();
  }

  List<DataRow> _buildRows(Map<String, dynamic> rowData, List<String> columns) {
    // Determine number of rows based on the length of any column values list
    int rowCount = rowData.isNotEmpty ? rowData[columns[0]]!.length : 0;

    // Build data rows
    return List.generate(rowCount, (index) {
      return DataRow(
        cells: columns.map((column) {
          // Extract value for each column at the current row index
          dynamic value = rowData[column]![index.toString()];
          return DataCell(Text(value.toString()));
        }).toList(),
      );
    });
  }
}
