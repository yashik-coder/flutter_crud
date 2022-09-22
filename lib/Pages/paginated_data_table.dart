// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/Pages/search_page.dart';
import 'package:flutter_crud/Pages/userviewpage.dart';
import 'package:flutter_crud/addscreens/add_employee.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_crud/Employee_Model/employee_model.dart';
import 'package:flutter_crud/Services/services.dart';
import 'package:flutter_crud/charts/cirrcularcharts.dart';

class Paginateddatatable extends StatefulWidget {
  const Paginateddatatable({Key? key}) : super(key: key);

  final String title = 'Flutter CRUD Operation';

  @override
  _PaginateddatatableState createState() => _PaginateddatatableState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? timer;
  Debouncer({
    required this.milliseconds,
    this.action,
    this.timer,
  });

  run(VoidCallback action) {
    if (null != timer) {
      timer!
          .cancel(); // when the user is continuosly typing, this cancels the timer
    }
    // then we will start a new timer looking for the user to stop
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _PaginateddatatableState extends State<Paginateddatatable> {
  //final DataTableSource _data = MyData();
  //Typehead Suggestion
  bool loading = true;
  List<String> suggestons = [
    "USA",
    "UK",
    "Uganda",
    "Uruguay",
    "United Arab Emirates"
  ];

  var employee;
  var userModel = <Employee>[];
  late List<Employee> _filterEmployees;
  bool searchbox = false;
  late List<Employee> _employees;
  late String _titleProgress;
  final _debouncer = Debouncer(milliseconds: 1000);
  final _searchcontroller = TextEditingController();
  bool _searchfield = false;

  @override
  void initState() {
    _employees = [];
    _filterEmployees = [];
    _getEmployees();
    _dateEmployees();

    // TODO: implement initState
    super.initState();
  }

  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id, employee.image).then((result) {
      if ('success' == result) {
        _getEmployees();
        setState(() {
          loading = false;
        }); // Refresh after delete...
      }
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;

        _filterEmployees = employees;
        userModel = employees;
        loading = false;
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

  late List<Datewise> _datewise;
  var datemodel = <Datewise>[];

  _dateEmployees() async {
    await Services.dateEmployees().then((datesw) {
      setState(() {
        _datewise = datesw;
        datemodel = datesw;
        loading = false;
        // _chartData = datesw;
      });

      print("Length ${datesw.length}");
    });
  }

  bool _isSortAsc = true;
  int _currentSortColumn = 0;

  searchField() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: TextField(
        onChanged: (string) {
          // We will start filtering when the user types in the textfield.
          // Run the debouncer and start searching
          _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _filterEmployees = _employees
                  .where((u) => (u.firstName
                          .toLowerCase()
                          .contains(string.toLowerCase()) ||
                      u.lastName.toLowerCase().contains(string.toLowerCase())))
                  .toList();
            });
          });
        },
        decoration: InputDecoration(
          suffixIconColor: Colors.black,
          prefixIconColor: Colors.black,
          hintText: 'Search Employee List',
          fillColor: Colors.transparent,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon:
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              /* Clear the search field */
              setState(() {
                _searchcontroller.clear();
                _filterEmployees = _employees;
                searchbox = false;
              });
              FocusScope.of(context).unfocus();
            },
          ),
        ),
      ),
    );
  }

  Widget row(Employee user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          user.firstName,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          user.lastName,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _dtSource = MyData(
      userData: _filterEmployees,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carifer'),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const Icon(Icons.search))
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          searchbox ? searchField() : Container(),
                          //autocompletetext(),

                          PaginatedDataTable(
                            header: Text('Employee List'),
                            actions: <IconButton>[
                              IconButton(
                                iconSize: 25,
                                hoverColor: Colors.redAccent,
                                icon: const Icon(
                                  Icons.add_chart,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  Get.off(Circularchart(
                                    date: _datewise,
                                  ));
                                },
                              ),
                              IconButton(
                                  iconSize: 25,
                                  color: Colors.blueAccent,
                                  hoverColor: Colors.lightGreenAccent,
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddEmployee()));
                                  },
                                  icon: Icon(Icons.add)),
                              IconButton(
                                  iconSize: 25,
                                  color: Colors.blueAccent,
                                  hoverColor: Colors.lightGreenAccent,
                                  onPressed: () {
                                    setState(() {
                                      searchbox = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  )),
                            ],
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
                                      _filterEmployees.sort(
                                          (a, b) => b.count.compareTo(a.count));
                                    } else {
                                      _filterEmployees.sort(
                                          (a, b) => a.count.compareTo(b.count));
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
                                      _filterEmployees.sort((a, b) =>
                                          b.firstName.compareTo(a.id));
                                    } else {
                                      _filterEmployees.sort((a, b) =>
                                          a.firstName.compareTo(b.id));
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
                                      _filterEmployees.sort(
                                          (a, b) => b.lastName.compareTo(a.id));
                                    } else {
                                      _filterEmployees.sort((a, b) =>
                                          a.firstName.compareTo(b.id));
                                    }
                                    _isSortAsc = !_isSortAsc;
                                  });
                                },
                              ),
                              DataColumn(label: Text('Image')),
                              DataColumn(numeric: false, label: Text('Action'))
                            ],
                            columnSpacing: 100,
                            horizontalMargin: 10,
                            onRowsPerPageChanged: (perPage) {},
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                          ),
                        ],
                      ),
                    ),
                  )),
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
          Row(
            children: [
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.green,
                ),
                onPressed: () {
                  Get.to(() => UserDetailPages(
                        user: _user,
                      ));
                },
              ),
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  _deleteEmployee(_user);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}