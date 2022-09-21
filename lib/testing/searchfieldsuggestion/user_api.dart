import 'package:flutter/material.dart';


import 'dart:convert';
import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;

class User {
  final String name;

  const User({
    required this.name,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
      );
}

class UserApi {
  static Future<List<User>> getUserSuggestions(String query) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);

      return users.map((json) => User.fromJson(json)).where((user) {
        final nameLower = user.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
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