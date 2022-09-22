// Search Page

import 'package:flutter/material.dart';
import 'package:flutter_crud/Employee_Model/employee_model.dart';

import 'package:flutter_crud/testing/searchfieldsuggestion/user_api.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'userviewpage.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: TypeAheadField<Employee?>(
            hideSuggestionsOnKeyboardHide: false,
            textFieldConfiguration: const TextFieldConfiguration(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                hintText: 'Search Name',
                hoverColor: Colors.green,
              ),
            ),
            suggestionsCallback: UserApi.getUserSuggestions,
            itemBuilder: (context, Employee? suggestion) {
              final user = suggestion!;

              return Column(
                children: [
                  ListTile(
                    hoverColor: Colors.green,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25),
                            topRight: const Radius.circular(25),
                            bottomRight: const Radius.circular(25),
                            bottomLeft: const Radius.circular(25))),
                    tileColor: const Color.fromARGB(255, 108, 112, 136),
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    leading: Padding(
                      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.teal,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://192.168.29.77/EmployeesDB/images/${user.image}'),
                          radius: 28,
                        ),
                      ),
                    ),
                    isThreeLine: false,
                    title: Center(
                      child: Text(user.firstName.toUpperCase() +
                          ' ' +
                          user.lastName.toUpperCase()),
                    ),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.black54,
                  )
                ],
              );
            },
            noItemsFoundBuilder: (context) => Container(
              height: 100,
              child: const Center(
                child: Text(
                  'No Users Found.',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            onSuggestionSelected: (Employee? suggestion) {
              final user = suggestion!;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDetailPages(
                  user: user,
                ),
              ));
            },
          ),
        ),
      )),
    );
  }
}
