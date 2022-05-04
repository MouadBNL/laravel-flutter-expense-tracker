import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:app/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<CategoriesScreen> {
  late Future<List<Category>> futureCategories;
  final _formKey = GlobalKey<FormState>();
  late Category selectCategory;
  final categoryNameController = TextEditingController();

  Future<List<Category>> fetchCategories() async {
    http.Response response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/categories'));

    List categories = jsonDecode(response.body);

    return categories.map((cat) => Category.fromJson(cat)).toList();
  }

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  Future _saveCategory() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }
    String uri =
        'http://127.0.0.1:8000/api/categories/' + selectCategory.id.toString();

    await http.put(
      Uri.parse(uri),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: jsonEncode({'name': categoryNameController.text}),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: FutureBuilder<List<Category>>(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Category category = snapshot.data![index];
                  return ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        selectCategory = category;
                        categoryNameController.text = category.name;
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.close),
                                            ),
                                            ElevatedButton(
                                                onPressed: () =>
                                                    _saveCategory(),
                                                child: Text('Save'))
                                          ],
                                        ),
                                      ),
                                      TextFormField(
                                        controller: categoryNameController,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Category name cannot be empty';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text('Category name'),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('something went wrong!'));
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
