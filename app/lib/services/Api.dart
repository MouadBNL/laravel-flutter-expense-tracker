import 'dart:convert';
import 'dart:io';

import 'package:app/models/Category.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseURI = 'http://127.0.0.1:8000/api/';
  ApiService();

  Future<List<Category>> fetchCategories() async {
    http.Response response = await http.get(Uri.parse(_baseURI + 'categories'));

    List categories = jsonDecode(response.body);

    return categories.map((cat) => Category.fromJson(cat)).toList();
  }

  Future<Category> updateCategory(int id, String name) async {
    String uri = _baseURI + 'categories/' + id.toString();

    try {
      http.Response res = await http.put(
        Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({'name': name}),
      );
      if (res.statusCode != 200) {
        throw Exception('An error has occured, please try again.');
      }
      return Category.fromJson(jsonDecode(res.body));
    } catch (e) {
      throw Exception('An error has occured, please try again.');
    }
  }
}
