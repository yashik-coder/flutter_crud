import 'dart:math';
import 'package:data_table_2/data_table_2.dart';
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/datatable_demo.dart';
import 'package:flutter_crud/listview_data.dart';
import 'package:flutter_crud/practice_Image_upload/imageupload.dart';
import 'package:flutter_crud/screens/add_employee.dart';
import 'package:get/get.dart';
import 'package:flutter_crud/testing/paginated_data_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),

      //home: listdata(),
      //home: DataTableDemo(),
      home: Paginateddatatable(),
      //home: AddEmployee(),
      //home: const UploadImage(title: 'Image Upload'),
      //home: Home(),
      // home: const MyHomePage(
      //   title: 'demo',
      // ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataTableSource _data = MyData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      body: PaginatedDataTable(
        source: _data,
        header: const Text('My Products'),
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('test price'))
        ],
        columnSpacing: 100,
        horizontalMargin: 10,
        rowsPerPage: 8,
        showCheckboxColumn: false,
      ),
    );
  }
}

// The "soruce" of the table
class MyData extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = List.generate(
      200,
      (index) => {
            "id": index,
            "title": "Item $index",
            "price": Random().nextInt(10000)
          });

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['id'].toString())),
      DataCell(Text(_data[index]["title"])),
      DataCell(Text(_data[index]["price"].toString())),
      DataCell(Text(_data[index]["price"].toString())),
    ]);
  }
}
