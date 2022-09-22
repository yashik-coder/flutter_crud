// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;

import '../../Employee_Model/employee_model.dart';



class UserApi {
  static Future<List<Employee>> getUserSuggestions(String query) async {
    final url =
        Uri.parse('http://192.168.29.77/EmployeesDB/emplyees_action.php');
    var map = <String, dynamic>{};
    map['action'] = 'GET_ALL';
    final response = await http.post(url, body: map);
    print(response);

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);

      return users.map((json) => Employee.fromJson(json)).where((user) {
        final nameLower = user.firstName.toLowerCase();
        final lastlower = user.lastName.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower) || lastlower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}

class Useri {
  final String name;
  final String imageUrl;

  const Useri({
    required this.name,
    required this.imageUrl,
  });
}

class UserData {
  static final faker = Faker();
  static final List<Useri> users = List.generate(
    50,
    (index) => Useri(
      name: faker.person.name(),
      imageUrl: 'https://source.unsplash.com/random?user+face&sig=$index',
    ),
  );

  static List<Useri> getSuggestions(String query) =>
      List.of(users).where((Useri) {
        final userLower = Useri.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return userLower.contains(queryLower);
      }).toList();
}
