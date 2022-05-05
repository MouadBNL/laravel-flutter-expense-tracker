import 'package:app/models/Category.dart';
import 'package:app/widgets/categories/add.dart';
import 'package:app/widgets/categories/edit.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:app/providers/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<CategoriesScreen> {
  Future deleteCategory(Function callback, Category category) async {
    await callback(category);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    List<Category> categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          Category category = categories[index];
          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return CategoryEdit(category, provider.updateCategory);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: Text(
                            'Are you sure you want to delete ${category.name} category ?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => deleteCategory(
                              provider.deleteCategory,
                              category,
                            ),
                            child: const Text('Confirm'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return CategoryAdd(provider.addCategory);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
