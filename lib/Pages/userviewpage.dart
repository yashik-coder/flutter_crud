// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_crud/Employee_Model/employee_model.dart';

import '../testing/searchfieldsuggestion/user_api.dart';

class UserDetailPages extends StatelessWidget {
  final Employee user;
  const UserDetailPages({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Card(
          elevation: 50,
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 20,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      'http://192.168.29.77/EmployeesDB/images/${user.image}',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    user.firstName.toUpperCase() +
                                        ' ' +
                                        user.lastName.toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
              Positioned(
                top: 5,
                left: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 2),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                    // the method which is called
                    // when button is pressed
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
