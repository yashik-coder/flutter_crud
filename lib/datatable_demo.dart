import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/Employee_Model/employee_model.dart';
import 'package:flutter_crud/Services/services.dart';

class DataTableDemo extends StatefulWidget {
  //
  // ignore: use_key_in_widget_constructors
  const DataTableDemo() : super();

  final String title = 'Flutter CRUD Operation';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  late List<Employee> _employees;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the First Name TextField we are going to create.
  late TextEditingController _firstNameController;
  // controller for the Last Name TextField we are going to create.
  late TextEditingController _lastNameController;
  late Employee _selectedEmployee;
  late bool _isUpdating;
  late String _titleProgress;
  late bool _istextfieldshow;
  late bool _submitbuttonshow;
  late bool _addfieldbutton;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _istextfieldshow = false;
    _submitbuttonshow = false;
    _addfieldbutton = true;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployees();
  }

  ScrollController _scrollController1 = ScrollController();
  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      if ('success' == result) {
        // Table is created successfully.
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  // Now lets add an Employee
  _addEmployee() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('Adding Employee...');
    Services.addEmployee(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        FocusScope.of(context).unfocus();
        _istextfieldshow = false;
        _submitbuttonshow = false;
        _getEmployees(); // Refresh the List after adding each employee...
        _clearValues();
      }
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${employees.length}");
    });
  }

  _updateEmployee(Employee employee) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating Employee...');
    Services.updateEmployee(
            employee.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _istextfieldshow = false;
        FocusScope.of(context).unfocus();
        _getEmployees(); // Refresh the list after update
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id).then((result) {
      if ('success' == result) {
        _getEmployees(); // Refresh after delete...
      }
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  _showValues(Employee employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
  }

  // Let's create a DataTable and show the employee list in it.
  Widget _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return DataTable(
      columns: const [
        DataColumn(
          label: Text('ID'),
        ),
        DataColumn(
          label: Text('FIRST NAME'),
        ),
        DataColumn(
          label: Text('LAST NAME'),
        ),
        // Lets add one more column to show a delete button
        DataColumn(
          label: Text('DELETE'),
        )
      ],
      rows: _employees
          .map(
            (employee) => DataRow(cells: [
              DataCell(
                Text(employee.id),
                // Add tap in the row and populate the
                // textfields with the corresponding values to update
                onTap: () {
                  _showValues(employee);
                  // Set the Selected employee to Update
                  _selectedEmployee = employee;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(
                  employee.firstName.toUpperCase(),
                ),
                onTap: () {
                  _showValues(employee);
                  // Set the Selected employee to Update
                  _selectedEmployee = employee;
                  // Set flag updating to true to indicate in Update Mode
                  setState(() {
                    _isUpdating = true;
                    _istextfieldshow = true;
                    _submitbuttonshow = false;
                  });
                },
              ),
              DataCell(
                Text(
                  employee.lastName.toUpperCase(),
                ),
                onTap: () {
                  _showValues(employee);
                  // Set the Selected employee to Update
                  _selectedEmployee = employee;
                  setState(() {
                    _isUpdating = true;
                    _istextfieldshow = true;
                    _submitbuttonshow = false;
                  });
                },
              ),
              DataCell(IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  _deleteEmployee(employee);
                },
              ))
            ]),
          )
          .toList(),
    );
  }

  //test
  final _verticalScrollController1 = ScrollController();
  final _horizontalScrollController1 = ScrollController();

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress), // we show the progress in the title...
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _createTable();
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _getEmployees();
              },
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _istextfieldshow
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                controller: _firstNameController,
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'First Name',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                controller: _lastNameController,
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Last Name',
                                ),
                              ),
                            ),
                            _submitbuttonshow
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        side: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      child: const Text('Submit'),
                                      onPressed: () {
                                        _addEmployee();
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                  // Add an update button and a Cancel Button
                  // show these buttons only when updating an employee
                  _isUpdating
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: BorderSide(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                child: const Text('UPDATE'),
                                onPressed: () {
                                  _updateEmployee(_selectedEmployee);
                                },
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: BorderSide(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                child: const Text('CANCEL'),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _isUpdating = false;
                                    _submitbuttonshow = false;
                                    _istextfieldshow = false;
                                  });
                                  _clearValues();
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Employee List',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                  //start
                  Container(
                    height: 300,
                    width: 700,
                    child: AdaptiveScrollbar(
                      underColor: Colors.green.withOpacity(0.3),
                      sliderDefaultColor: Colors.green.withOpacity(0.7),
                      sliderActiveColor: Colors.green,
                      controller: _verticalScrollController1,
                      child: AdaptiveScrollbar(
                        controller: _horizontalScrollController1,
                        position: ScrollbarPosition.bottom,
                        underColor: Colors.blueGrey.withOpacity(0.3),
                        sliderDefaultColor: Colors.grey.withOpacity(0.7),
                        sliderActiveColor: Colors.grey,
                        child: SingleChildScrollView(
                          controller: _verticalScrollController1,
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            controller: _horizontalScrollController1,
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 16.0),
                                child: _dataBody()),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //End
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _addfieldbutton
            ? FloatingActionButton(
                splashColor: Colors.green,
                onPressed: () {
                  _addEmployee();
                  setState(() {
                    _istextfieldshow = true;
                    _submitbuttonshow = true;
                    _addfieldbutton = false;
                  });
                },
                child: const Icon(Icons.add),
              )
            : FloatingActionButton(
                splashColor: Colors.green,
                onPressed: () {
                  setState(() {
                    _istextfieldshow = false;
                    _submitbuttonshow = false;
                    _addfieldbutton = true;
                  });
                },
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ));
  }
}
