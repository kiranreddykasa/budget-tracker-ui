import 'package:budget_tracker/common/ui/BudgetDrawer.dart';
import 'package:budget_tracker/transaction/AmountPerCategory.dart';
import 'package:budget_tracker/transaction/report/AmountPerCategoryPresenter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AmountPerCategoryChart extends StatefulWidget {
  @override
  _AmountPerCategoryChartState createState() => _AmountPerCategoryChartState();
}

class _AmountPerCategoryChartState extends State<AmountPerCategoryChart>
    implements AmountPerCategoryViewContract {
  AmountPerCategoryViewPresenter _presenter;
  bool _isLoading;
  String _selectedMonth;
  String _selectedYear;
  String _transactionType;
  List<AmountPerCategory> _amountPerCategories;

  _AmountPerCategoryChartState() {
    _presenter = AmountPerCategoryViewPresenter(this);
  }

  @override
  initState() {
    super.initState();
    _isLoading = true;
    _selectedMonth = '${DateTime.now().month}';
    print(_selectedMonth);
    _selectedYear = '${DateTime.now().year}';
    _transactionType = "D";
    _presenter.retrieveAmountPerCategory(
        '$_selectedMonth-$_selectedYear', _transactionType);
  }

  @override
  Widget build(BuildContext context) {
    var widget;

    if (_isLoading) {
      widget = Center(child: CircularProgressIndicator());
    } else
      widget = Container(
        margin: EdgeInsets.all(16.0),
        child: Column(children: [
          Row(children: [
            Expanded(child: monthSelector()),
            Container(padding: EdgeInsets.only(right: 10.0)),
            Expanded(child: yearSelector()),
          ]),
          Container(padding: EdgeInsets.only(bottom: 25.0)),
          Expanded(child: chartsWidget())
        ]),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Report'),
      ),
      drawer: BudgetDrawer(),
      body: widget,
    );
  }

  Widget monthSelector() {
    return InputDecorator(
      decoration: InputDecoration(labelText: "Month"),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            hint: Text("Select Month"),
            isDense: true,
            items: [
              '01',
              '02',
              '03',
              '04',
              '05',
              '06',
              '07',
              '08',
              '09',
              '10',
              '11',
              '12'
            ].map((String month) {
              return DropdownMenuItem<String>(
                child: Text(month),
                value: month,
              );
            }).toList(),
            value: _selectedMonth,
            onChanged: (String month) {
              setState(() {
                if (month != null) {
                  _isLoading = true;
                  _selectedMonth = month;
                  print('$_selectedMonth-$_selectedYear');
                  _presenter.retrieveAmountPerCategory(
                      '$_selectedMonth-$_selectedYear', _transactionType);
                }
              });
            }),
      ),
    );
  }

  Widget yearSelector() {
    return InputDecorator(
      decoration: InputDecoration(labelText: "Year"),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            hint: Text("Select Year"),
            isDense: true,
            items: ['2018', '2017', '2016', '2015'].map((String year) {
              return DropdownMenuItem<String>(
                child: Text('$year'),
                value: year,
              );
            }).toList(),
            value: _selectedYear,
            onChanged: (String year) {
              setState(() {
                if (year != null) {
                  _isLoading = true;
                  _selectedYear = year;
                  _presenter.retrieveAmountPerCategory(
                      '$_selectedMonth-$_selectedYear', _transactionType);
                }
              });
            }),
      ),
    );
  }

  Widget chartsWidget() {
    var chartSeries = [
      charts.Series<AmountPerCategory, String>(
        id: 'AmountPerCategory',
        domainFn: (AmountPerCategory amountPerCategory, _) =>
            amountPerCategory.category,
        measureFn: (AmountPerCategory amountPerCategory, _) =>
            amountPerCategory.totalAmount,
        labelAccessorFn: (AmountPerCategory amountPerCategory, _) =>
            '${amountPerCategory.category}  ${amountPerCategory.totalAmount}',
        data: _amountPerCategories,
      )
    ];
    return _amountPerCategories.length == 0
        ? Container(
            child: Center(child: Text("No data available for selected month")),
          )
        : _amountPerCategories.length == 1
            ? barChart(chartSeries)
            : pieChart(chartSeries);
  }

  Widget barChart(chartSeries) {
    return charts.BarChart(
      chartSeries,
      animate: true,
    );
  }

  Widget pieChart(chartSeries) {
    return charts.PieChart(chartSeries,
        animate: true,
        defaultRenderer:  charts.ArcRendererConfig(
            arcWidth: 100,
            arcRendererDecorators: [ charts.ArcLabelDecorator()]));
  }

  @override
  void showAmountPerCategory(List<AmountPerCategory> amountPerCategories) {
    setState(() {
      _amountPerCategories = amountPerCategories;
      _isLoading = false;
    });
  }

  @override
  void showError() {
    // TODO: implement showError
  }
}
