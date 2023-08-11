import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/model/approval_list_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeViewModel extends ChangeNotifier {
  List<ApprovalListItem> _data = [];
  List<ApprovalListItem> get data => _data;

  Future<void> fetchData() async {
    try {
      final apiUrl = "${Constants.apiURL}/siaga-trans/app-aju"; // Replace with your API URL
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        _data = data.map((item) => ApprovalListItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load approval list');
      }
    } catch (e) {
      // Handle errors as needed
      print('Error fetching data: $e');
    }

    // Notify listeners about the data change
    notifyListeners();
  }
}
