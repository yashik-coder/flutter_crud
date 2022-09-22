import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_crud/Employee_Model/employee_model.dart';
import 'package:flutter_crud/Pages/paginated_data_table.dart';
import 'package:flutter_crud/datatable_demo.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddEmployee extends StatefulWidget {
  final Employee? employee;

  const AddEmployee({super.key, this.employee});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final empfname = TextEditingController();
  final emplname = TextEditingController();
  final empemail = TextEditingController();

  var image;

  //List _images = [];
  var finalfile;

  final ImagePicker picker = ImagePicker();

  Future sendImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    // print('final Img $img');

    setState(() {
      finalfile = img;
    });
    print('final Img $finalfile');

    // var uri = "http://192.168.29.77/flutter_upload_image/create.php";

    // var request = http.MultipartRequest('POST', Uri.parse(uri));

    // if (img != null) {
    //   var pic = await http.MultipartFile.fromPath("image", img.path);

    //   request.files.add(pic);
    //   request.fields['name'] = 'Ramesh';

    //   await request.send().then((result) {
    //     http.Response.fromStream(result).then((response) {
    //       var message = jsonDecode(response.body);

    //       // show snackbar if input data successfully
    //       final snackBar = SnackBar(content: Text(message['message']));
    //       ScaffoldMessenger.of(context).showSnackBar(snackBar);

    //       //get new list images
    //     });
    //   }).catchError((e) {
    //     print(e);
    //   });
    // }
  }

  Future AddEmployee(String fname, lname, var image) async {
    var action = 'ADD_EMP';
    var uri = "http://192.168.29.77/EmployeesDB/emplyees_action.php/";

    var request = http.MultipartRequest('POST', Uri.parse(uri));

    if (image != null) {
      var pic = await http.MultipartFile.fromPath("image", image.path);

      request.files.add(pic);
      request.fields['action'] = action;
      request.fields['first_name'] = fname;
      request.fields['last_name'] = lname;

      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {
          final snackBar =
              SnackBar(content: Text('AddEmployee ${response.body}'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print('addEmployee Response: ${response.body}');
          return response.body;

          // //get new list images
        });
      }).catchError((e) {
        print(e);
      });
    }
  }

  Future updateEmployee(
      String fname, lname, empid, Previousimage, var image) async {
    var action = 'UPDATE_EMP';
    var uri = "http://192.168.29.77/EmployeesDB/emplyees_action.php/";

    var request = http.MultipartRequest('POST', Uri.parse(uri));

    if (image != null) {
      var pic = await http.MultipartFile.fromPath("image", image.path);

      request.files.add(pic);

      request.fields['action'] = action;

      request.fields['previous_img'] = Previousimage;
      request.fields['emp_id'] = empid;
      request.fields['first_name'] = fname;
      request.fields['last_name'] = lname;

      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {
          final snackBar = SnackBar(content: Text('updateEmployee'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print('updateEmployee Response: ${response.body}');
          return response.body;

          // //get new list images
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      request.fields['action'] = action;

      request.fields['previous_img'] = Previousimage;
      request.fields['emp_id'] = empid;
      request.fields['first_name'] = fname;
      request.fields['last_name'] = lname;

      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {
          final snackBar = SnackBar(content: Text('updateEmployee'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print('updateEmployee Response: ${response.body}');
          return response.body;

          // //get new list images
        });
      }).catchError((e) {
        print(e);
      });
    }
  }

  _showValues(Employee employee) {
    empfname.text = employee.firstName;
    emplname.text = employee.lastName;
  }

  @override
  void initState() {
    widget.employee != null ? _showValues(widget.employee!) : _clearValues();
    // TODO: implement initState
    super.initState();
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () async {
                      // var file_img =
                      //     await picker.pickImage(source: ImageSource.gallery);
                      // setState(() {
                      //   file_img = image;
                      // });
                      Navigator.pop(context);
                      sendImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      sendImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _clearValues() {
    empfname.text = '';
    emplname.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Paginateddatatable()));
          },
        ),
        automaticallyImplyLeading: false,
        title: widget.employee != null
            ? Text('Update Employee Details')
            : Text('Add Employee Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // widget.employee != null
                  //     ? Column(
                  //         children: [
                  //           Text(widget.employee!.firstName.toString()),
                  //           Text(widget.employee!.lastName.toString()),
                  //           Text(widget.employee!.image.toString()),
                  //         ],
                  //       )
                  //     : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: empfname,
                      decoration: InputDecoration(
                          labelText: 'Employee First Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.red),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: emplname,
                      decoration: InputDecoration(
                          labelText: 'Employee Last Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.red),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: OutlinedButton(
                            onPressed: () {
                              myAlert();
                            },
                            child: Text('Choose Image')),
                      ),
                      Expanded(child: Container()),
                      finalfile != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Container(
                                width: 100,
                                height: 50,
                                child: Image.file(
                                  File(finalfile.path),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : widget.employee != null
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                      'http://192.168.29.77/EmployeesDB/images/${widget.employee!.image}'),
                                )
                              : Container(),
                    ],
                  ),
                  widget.employee != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    print(finalfile);

                                    if (empfname.text != null &&
                                        emplname != null) {
                                      await updateEmployee(
                                          empfname.text,
                                          emplname.text,
                                          widget.employee!.id,
                                          widget.employee!.image,
                                          finalfile);

                                      empfname.text = '';
                                      emplname.text = '';
                                      finalfile = '';
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Paginateddatatable()));
                                    } else {
                                      final snackBar = SnackBar(
                                          content: Text(
                                              'Please Enter a all Fields'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Update'),
                                  ))),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    print(finalfile);
                                    if (empfname.text != null &&
                                        emplname != null &&
                                        finalfile != null) {
                                      await AddEmployee(empfname.text,
                                          emplname.text, finalfile);

                                      empfname.text = '';
                                      emplname.text = '';
                                      finalfile = '';
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Paginateddatatable()));
                                    } else {
                                      final snackBar = SnackBar(
                                          content: Text(
                                              'Please Enter a all Fields'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Submit'),
                                  ))),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class textfield extends StatelessWidget {
  const textfield({
    Key? key,
    required this.controllert,
  }) : super(key: key);

  final TextEditingController controllert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controllert,
        decoration: InputDecoration(
            labelText: 'Employee Name',
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Colors.blue),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            )),
      ),
    );
  }
}
