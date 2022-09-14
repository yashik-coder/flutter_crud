import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/datatable_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: DataTableDemo(),
      // home: const MyHomePage(
      //   title: 'demo',
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final _verticalScrollController = ScrollController();
    final _horizontalScrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: 300,
        width: 700,
        child: AdaptiveScrollbar(
          underColor: Colors.blueGrey.withOpacity(0.3),
          sliderDefaultColor: Colors.grey.withOpacity(0.7),
          sliderActiveColor: Colors.grey,
          controller: _verticalScrollController,
          child: AdaptiveScrollbar(
            controller: _horizontalScrollController,
            position: ScrollbarPosition.bottom,
            underColor: Colors.blueGrey.withOpacity(0.3),
            sliderDefaultColor: Colors.grey.withOpacity(0.7),
            sliderActiveColor: Colors.grey,
            child: SingleChildScrollView(
              controller: _verticalScrollController,
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                  child: DataTable(
                    showCheckboxColumn: true,
                    columns: const [
                      DataColumn(
                        label: Text('Name'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Name'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                      DataColumn(
                        label: Text('Year'),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      20,
                      (int index) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                          DataCell(
                            Text('Row $index'),
                          ),
                        ],
                        onSelectChanged: (bool? value) {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
