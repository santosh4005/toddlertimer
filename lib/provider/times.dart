import 'package:flutter/foundation.dart';
import '../helper/dbhelper.dart';
import '../models/toddlertime.dart';

class ProviderToddlerTimes with ChangeNotifier {
  List<ModelToddlerTime> _items = [];

  List<ModelToddlerTime> get items {
    return [..._items];
  }

  List<ModelToddlerTime> fetchTimesOfType(String type) {
    return _items.where((element) => element.type.toLowerCase().contains(type.toLowerCase())).toList();
  }

  Future<void> fetchAndSetTimes() async {
    final workoutlist = await DBHelper.getData();
    _items = workoutlist
        .map((e) => ModelToddlerTime(
              id: e['id'],
              type: e['type'],
              date: DateTime.parse(e['date']),
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addTime(ModelToddlerTime item) async {
    await DBHelper.insert({
      'id': item.id,
      'date': item.date.toString(),
      'type': item.type,
    });

    _items.insert(0, item);
    notifyListeners();
  }

  Future<void> deleteRecord(String id) async {
    await DBHelper.delete(id);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> deleteDatabase() async {
    await DBHelper.deleteDB();
    _items.clear();
    notifyListeners();
  }
}
