import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _xAxis =
          prefs.getStringList('ff_xAxis')?.map(double.parse).toList() ?? _xAxis;
    });
    _safeInit(() {
      _yAxis =
          prefs.getStringList('ff_yAxis')?.map(double.parse).toList() ?? _yAxis;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<double> _xAxis = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0];
  List<double> get xAxis => _xAxis;
  set xAxis(List<double> _value) {
    _xAxis = _value;
    prefs.setStringList('ff_xAxis', _value.map((x) => x.toString()).toList());
  }

  void addToXAxis(double _value) {
    _xAxis.add(_value);
    prefs.setStringList('ff_xAxis', _xAxis.map((x) => x.toString()).toList());
  }

  void removeFromXAxis(double _value) {
    _xAxis.remove(_value);
    prefs.setStringList('ff_xAxis', _xAxis.map((x) => x.toString()).toList());
  }

  void removeAtIndexFromXAxis(int _index) {
    _xAxis.removeAt(_index);
    prefs.setStringList('ff_xAxis', _xAxis.map((x) => x.toString()).toList());
  }

  void updateXAxisAtIndex(
    int _index,
    double Function(double) updateFn,
  ) {
    _xAxis[_index] = updateFn(_xAxis[_index]);
    prefs.setStringList('ff_xAxis', _xAxis.map((x) => x.toString()).toList());
  }

  void insertAtIndexInXAxis(int _index, double _value) {
    _xAxis.insert(_index, _value);
    prefs.setStringList('ff_xAxis', _xAxis.map((x) => x.toString()).toList());
  }

  List<double> _yAxis = [2.0, 3.0, 6.0, 4.0, 5.0, 3.0, 4.0];
  List<double> get yAxis => _yAxis;
  set yAxis(List<double> _value) {
    _yAxis = _value;
    prefs.setStringList('ff_yAxis', _value.map((x) => x.toString()).toList());
  }

  void addToYAxis(double _value) {
    _yAxis.add(_value);
    prefs.setStringList('ff_yAxis', _yAxis.map((x) => x.toString()).toList());
  }

  void removeFromYAxis(double _value) {
    _yAxis.remove(_value);
    prefs.setStringList('ff_yAxis', _yAxis.map((x) => x.toString()).toList());
  }

  void removeAtIndexFromYAxis(int _index) {
    _yAxis.removeAt(_index);
    prefs.setStringList('ff_yAxis', _yAxis.map((x) => x.toString()).toList());
  }

  void updateYAxisAtIndex(
    int _index,
    double Function(double) updateFn,
  ) {
    _yAxis[_index] = updateFn(_yAxis[_index]);
    prefs.setStringList('ff_yAxis', _yAxis.map((x) => x.toString()).toList());
  }

  void insertAtIndexInYAxis(int _index, double _value) {
    _yAxis.insert(_index, _value);
    prefs.setStringList('ff_yAxis', _yAxis.map((x) => x.toString()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
