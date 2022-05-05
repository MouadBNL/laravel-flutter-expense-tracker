import 'dart:convert';
import 'dart:io';

import 'package:app/models/Category.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseURI = 'http://127.0.0.1:8000/api/';
  final _apiHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };
  ApiService();

  Future<List<Category>> fetchCategories() async {
    http.Response response = await http.get(Uri.parse(_baseURI + 'categories'));

    List categories = jsonDecode(response.body);

    return categories.map((cat) => Category.fromJson(cat)).toList();
  }

  Future<Category> updateCategory(Category category) async {
    String uri = _baseURI + 'categories/' + category.id.toString();

    try {
      http.Response res = await http.put(
        Uri.parse(uri),
        headers: _apiHeaders,
        body: jsonEncode({'name': category.name}),
      );
      if (res.statusCode != 200) {
        throw Exception('An error has occured, please try again.');
      }
      return Category.fromJson(jsonDecode(res.body));
    } catch (e) {
      throw Exception('An error has occured, please try again.');
    }
  }

  Future deleteCategory(int id) async {
    String uri = _baseURI + 'categories/' + id.toString();

    try {
      http.Response res = await http.delete(
        Uri.parse(uri),
        headers: _apiHeaders,
      );
      if (res.statusCode != 204) {
        throw Exception(
            'An error has occured, please try again. status code invalid');
      }
    } catch (e) {
      throw Exception('An error has occured in api, please try again.');
    }
  }

  Future<Category> addCategory(String name) async {
    String uri = _baseURI + 'categories';

    try {
      http.Response res = await http.post(
        Uri.parse(uri),
        headers: _apiHeaders,
        body: jsonEncode({'name': name}),
      );
      if (res.statusCode != 201) {
        throw Exception();
      }
      return Category.fromJson(jsonDecode(res.body));
    } catch (e) {
      throw Exception('An error has occured, please try again.');
    }
  }

  Future<String> register(String name, String email, String password,
      String passwordConfirm, String deviceName) async {
    String uri = _baseURI + 'auth/register';

    http.Response res = await http.post(
      Uri.parse(uri),
      headers: _apiHeaders,
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
        'device_name': deviceName
      }),
    );
    if (res.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(res.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }

    return res.body;
  }
}
