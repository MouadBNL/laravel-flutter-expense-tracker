import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<CategoriesScreen> {
  final List<String> categories = [
    'My category',
    'Category 2',
    'last category'
  ];

  int clicked = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories, clicked: ' + clicked.toString()),
      ),
      body: Container(
        child: Center(
          child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => setState(() {
                    clicked++;
                  }),
                  title: Text(
                    categories[index],
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          clicked++;
        }),
        tooltip: 'increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
