import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Date & Location Filter')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
          },
          child: Text('Open Filter Page'),
        ),
      ),
    );
  }
}

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  String? _selectedLocation = 'Location A';

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedFromDate) {
      setState(() {
        _selectedFromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedToDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedToDate) {
      setState(() {
        _selectedToDate = picked;
      });
    }
  }

  void _onLocationChanged(String? value) {
    setState(() {
      _selectedLocation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter Data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'From Date: ${DateFormat('yyyy-MM-dd').format(_selectedFromDate)}',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () => _selectFromDate(context),
              child: Text('Select From Date'),
            ),
            SizedBox(height: 16),
            Text(
              'To Date: ${DateFormat('yyyy-MM-dd').format(_selectedToDate)}',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () => _selectToDate(context),
              child: Text('Select To Date'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedLocation,
              onChanged: _onLocationChanged,
              items: ['Location A', 'Location B', 'Location C']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Here, you can implement the logic to filter data using selected dates and location.
                // For example, you can use _selectedFromDate, _selectedToDate, and _selectedLocation to perform filtering.
                // You may pass these values to another function or widget to display filtered data.
                print('Filter Data');
              },
              child: Text('Filter Data'),
            ),
          ],
        ),
      ),
    );
  }
}
