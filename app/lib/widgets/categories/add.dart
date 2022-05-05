import 'package:app/models/Category.dart';
import 'package:app/services/Api.dart';
import 'package:flutter/material.dart';

class CategoryAdd extends StatefulWidget {
  final Function categoryAddCallback;
  CategoryAdd(this.categoryAddCallback, {Key? key}) : super(key: key);

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final _formKey = GlobalKey<FormState>();
  final categoryNameController = TextEditingController();
  String errorMessage = '';

  Future _addCategory() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }

    try {
      await widget.categoryAddCallback(categoryNameController.text);
      Navigator.pop(context);
    } catch (err) {
      setState(() {
        errorMessage = err.toString();
      });
    }
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
                      onPressed: () => _addCategory(),
                      child: Text('Create'),
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
