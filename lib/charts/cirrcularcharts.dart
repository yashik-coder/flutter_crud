import 'package:flutter/material.dart';
import 'package:flutter_crud/Employee_Model/employee_model.dart';
import 'package:flutter_crud/Services/services.dart';
import 'package:flutter_crud/testing/paginated_data_table.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class Circularchart extends StatefulWidget {
  final List<Datewise> date;

  const Circularchart({super.key, required this.date});

  @override
  State<Circularchart> createState() => _CircularchartState();
}

class _CircularchartState extends State<Circularchart> {
  late TooltipBehavior _tooltipBehavior;
  late List<Datewise> _chartData;
  late SelectionBehavior _selectionBehavior;

  @override
  void initState() {
    _selectionBehavior = SelectionBehavior(
        toggleSelection: false,
        enable: true,
        selectedColor: Colors.red,
        unselectedColor: Colors.grey);
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = widget.date;

    super.initState();
  }

  getdate(String datevalue) {
    DateTime dt = DateTime.parse(datevalue);
    print(dt); // 2020-01-02 03:04:05.000

    String ProcessedDate;

    ProcessedDate = dt.day.toString() +
        '/' +
        dt.month.toString() +
        '/' +
        dt.year.toString();

    return ProcessedDate;
  }
  //dummy line chart data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 247, 245),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            iconSize: 25,
            hoverColor: Colors.redAccent,
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
            onPressed: () {
              Get.offAll(const Paginateddatatable());
            },
          ),
          title: const Text('Employee Registration',
              style: TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: SfCircularChart(
            borderColor: Colors.transparent,
            // title: ChartTitle(text: 'Circular chart'),
            tooltipBehavior: _tooltipBehavior,
            legend: Legend(
              position: LegendPosition.bottom,
              toggleSeriesVisibility: true,
              title: LegendTitle(text: 'Datewise'),
              borderColor: Colors.black,
              borderWidth: 2,
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            series: <CircularSeries>[
              //pie to change Doughnut,RadialBar,
              PieSeries<Datewise, String>(
                selectionBehavior: _selectionBehavior,
                enableTooltip: true,
                dataSource: _chartData,
                sortingOrder: SortingOrder.ascending,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.average,
                    color: Colors.red,
                    borderColor: Colors.black,
                    borderWidth: 2),
                // xValueMapper: (Datewise data, _) => data.Date_wise,
                xValueMapper: (Datewise data, _) => getdate(data.Date_wise),
                yValueMapper: (Datewise data, _) =>
                    int.parse(data.count_employee_registration),

                dataLabelSettings: const DataLabelSettings(
                    labelPosition: ChartDataLabelPosition.outside,
                    isVisible: true),
                //maximumValue: 2500,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<GDPDATA> getchartData() {
    final List<GDPDATA> chartData = [
      GDPDATA('America', 1600),
      GDPDATA('Africa', 2490),
      GDPDATA('Europe', 2350),
      GDPDATA('India', 2740),
      GDPDATA('Germany', 2240),
      GDPDATA('Maldives', 2140),
    ];
    return chartData;
  }
}

class GDPDATA {
  final String continent;
  final int gdp;
  GDPDATA(this.continent, this.gdp);
}
