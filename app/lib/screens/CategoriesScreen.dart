import 'package:app/models/Category.dart';
import 'package:app/services/Api.dart';
import 'package:app/widgets/categories/edit.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<CategoriesScreen> {
  late Future<List<Category>> futureCategories;
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureCategories = apiService.fetchCategories();
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
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CategoryEdit(category);
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
