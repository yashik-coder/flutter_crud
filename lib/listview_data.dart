import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class listdata extends StatefulWidget {
  const listdata({Key? key}) : super(key: key);

  @override
  State<listdata> createState() => _listdataState();
}

class _listdataState extends State<listdata> {
  // this function is called when the app launches

  static const _GET_ALL_ACTION = 'GET_ALL';

  Future<List> _loadData() async {
    List posts = [];
    try {
      // This is an open REST API endpoint for testing purposes
      const apiUrl = 'http://192.168.29.77/EmployeesDB/emplyees_action.php';

      var map = <String, dynamic>{};
      map['action'] = _GET_ALL_ACTION;

      final http.Response response =
          await http.post(Uri.parse(apiUrl), body: map);
      posts = json.decode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Employee List'),
        ),
        // implement FutureBuilder
        body: FutureBuilder(
            future: _loadData(),
            builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
                snapshot.hasData
                    ? ListView.builder(
                        // render the list
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index) => Card(
                          margin: const EdgeInsets.all(10),
                          // render list item
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: CircleAvatar(
                                radius: 50,
                                child: Image.network(
                                    fit: BoxFit.cover,
                                    'http://192.168.29.77/EmployeesDB/images/${snapshot.data![index]['image']}')),
                            title: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child:
                                      Text(snapshot.data![index]['first_name']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child:
                                      Text(snapshot.data![index]['last_name']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        // render the loading indicator
                        child: CircularProgressIndicator(),
                      )));
  }
}
