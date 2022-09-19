import 'dart:async';

import 'dart:math';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
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

  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id, employee.image).then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh after delete...
      }
    });
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

  bool _isSortAsc = true;
  int _currentSortColumn = 0;

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
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: PaginatedDataTable(
            sortAscending: _isSortAsc,
            source: _dtSource,
            sortColumnIndex: _currentSortColumn,
            arrowHeadColor: Colors.blueAccent,
            columns: [
              DataColumn(
                numeric: true,
                label: Text('ID'),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isSortAsc) {
                      _employees.sort((a, b) => b.count.compareTo(a.count));
                    } else {
                      _employees.sort((a, b) => a.count.compareTo(b.count));
                    }
                    _isSortAsc = !_isSortAsc;
                  });
                },
              ),
              DataColumn(
                label: Text('First Name'),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isSortAsc) {
                      _employees.sort((a, b) => b.firstName.compareTo(a.id));
                    } else {
                      _employees.sort((a, b) => a.firstName.compareTo(b.id));
                    }
                    _isSortAsc = !_isSortAsc;
                  });
                },
              ),
              DataColumn(
                label: Text('Last Name'),
                onSort: (columnIndex, _) {
                  setState(() {
                    _currentSortColumn = columnIndex;
                    if (_isSortAsc) {
                      _employees.sort((a, b) => b.lastName.compareTo(a.id));
                    } else {
                      _employees.sort((a, b) => a.firstName.compareTo(b.id));
                    }
                    _isSortAsc = !_isSortAsc;
                  });
                },
              ),
              DataColumn(label: Text('Image')),
              DataColumn(label: Text('Action'))
            ],
            columnSpacing: 100,
            horizontalMargin: 10,
            onRowsPerPageChanged: (perPage) {},
            rowsPerPage: 10,
            showCheckboxColumn: false,
          ),
        ),
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

  _deleteEmployee(Employee employee) {
    // _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id, employee.image).then((result) {
      if ('success' == result) {
        // _getEmployees(); // Refresh after delete...
        Get.offAll(() => Paginateddatatable());
        Get.snackbar('', 'Deleted Successfully');
      }
    });
  }

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
        DataCell(onTap: () {
          Get.off(() => AddEmployee(
                employee: _user,
              ));
        }, Text('${_user.count}')),
        DataCell(onTap: () {
          Get.off(AddEmployee(
            employee: _user,
          ));
        }, Text('${_user.firstName}')),
        DataCell(onTap: () {
          Get.off(() => AddEmployee(
                employee: _user,
              ));
        }, Text('${_user.lastName}')),
        DataCell(onTap: () {
          Get.off(() => AddEmployee(
                employee: _user,
              ));
        },
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      'http://192.168.29.77/EmployeesDB/images/${_user.image}'),
                ),
              ],
            )),
        DataCell(
          IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteEmployee(_user);
            },
          ),
        ),
      ],
    );
  }
}
