import 'package:app/models/Category.dart';
import 'package:app/services/Api.dart';
import 'package:flutter/material.dart';

class CategoryEdit extends StatefulWidget {
  final Category category;
  CategoryEdit(this.category, {Key? key}) : super(key: key);

  @override
  State<CategoryEdit> createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  final _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  final apiService = ApiService();
  String errorMessage = '';

  @override
  void initState() {
    categoryNameController.text = widget.category.name;
    super.initState();
  }

  Future _saveCategory() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }

    apiService
        .updateCategory(
      widget.category.id,
      categoryNameController.text,
    )
        .then((Category cat) {
      Navigator.pop(context);
    }).catchError((err) {
      setState(() {
        errorMessage = err.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                    ),
                    ElevatedButton(
                      onPressed: () => _saveCategory(),
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: categoryNameController,
                onChanged: (text) {
                  setState(() {
                    errorMessage = '';
                  });
                },
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
