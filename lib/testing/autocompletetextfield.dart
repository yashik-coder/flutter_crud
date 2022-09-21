// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AutoCompleteDemo extends StatefulWidget {
  AutoCompleteDemo() : super();

  final String title = "AutoComplete Demo";

  @override
  _AutoCompleteDemoState createState() => _AutoCompleteDemoState();
}

class _AutoCompleteDemoState extends State<AutoCompleteDemo> {
  late AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = GlobalKey();
  static List<User> users = <User>[];
  static const _GET_ALL_ACTION = 'GET_ALL';
  bool loading = true;
  // ignore: non_constant_identifier_names
  static Uri ROOT =
      Uri.parse('http://192.168.29.77/EmployeesDB/emplyees_action.php');
  late List<User> _filterEmployees;

  void getUsers() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        users = loadUsers(response.body);
        print('Users: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  @override
  void initState() {
    getUsers();
    _filterEmployees = [];
    super.initState();
  }

  Widget row(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          user.first_name,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          user.last_name,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : searchTextField = AutoCompleteTextField<User>(
            key: key,
            clearOnSubmit: false,
            suggestions: users,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              hintText: "Search Name",
              hintStyle: TextStyle(color: Colors.black),
            ),
            itemFilter: (item, query) {
              return item.first_name
                      .toLowerCase()
                      .startsWith(query.toLowerCase()) ||
                  item.last_name.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.first_name.compareTo(b.first_name);
            },
            itemSubmitted: (item) {
              setState(() {
                searchTextField.textField!.controller?.text = item.first_name;
               
              });
            },
            itemBuilder: (context, item) {
              // ui for the autocompelete row
              return row(item);
            },
          );
  }
}

class User {
  int count;
  String first_name;
  String last_name;
  User({
    required this.count,
    required this.first_name,
    required this.last_name,
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      count: parsedJson["count"],
      first_name: parsedJson["first_name"] as String,
      last_name: parsedJson["last_name"] as String,
    );
  }
}
