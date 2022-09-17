import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_crud/Employee_Model/employee_model.dart';
import 'package:flutter_crud/Services/services.dart';
import 'package:flutter_crud/screens/add_employee.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Paginateddatatable extends StatefulWidget {
  const Paginateddatatable({Key? key}) : super(key: key);

  final String title = 'Flutter CRUD Operation';

  @override
  _PaginateddatatableState createState() => _PaginateddatatableState();
}

class _PaginateddatatableState extends State<Paginateddatatable> {
  //final DataTableSource _data = MyData();

  var employee;
  var userModel = <Employee>[];

  late List<Employee> _employees;
  late String _titleProgress;
  @override
  void initState() {
    _employees = [];
    _getEmployees();

    // TODO: implement initState
    super.initState();
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
        userModel = employees;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employees.length}");
    });
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _dtSource = MyData(
      userData: _employees,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddEmployee()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: PaginatedDataTable(
        source: _dtSource,
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('First Name')),
          DataColumn(label: Text('Last Name')),
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Action'))
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
  MyData({
    required List<Employee> userData,
  })  : _userData = userData,
        assert(userData != null);

  final List<Employee> _userData;

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
  int get rowCount => _userData.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= _userData.length) {
      return null;
    }
    final _user = _userData[index];

    return DataRow.byIndex(
      index: index, // DONT MISS THIS
      cells: <DataCell>[
        DataCell(
              onTap: () {
                  // _showValues(employee);
                  // // Set the Selected employee to Update
                  // _selectedEmployee = employee;
                  // // Set flag updating to true to indicate in Update Mode
                  // setState(() {
                  //   _isUpdating = true;
                  //   _istextfieldshow = true;
                  //   _submitbuttonshow = false;
                  // });
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddEmployee(employee: _user)));
                },
          
          Text('${_user.id}')),
        DataCell(Text('${_user.firstName}')),
        DataCell(Text('${_user.lastName}')),
        DataCell(Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  'http://192.168.29.77/EmployeesDB/images/${_user.image}'),
            )
          ],
        )),
        DataCell(
          IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
