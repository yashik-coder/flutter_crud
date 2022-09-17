import 'dart:convert';

class Employee {
  String id;
  String firstName;
  String lastName;
  String image;

  Employee(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.image});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      image:
           json['image'] as String,
    );
  }
}
List<Employee> userModelFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));