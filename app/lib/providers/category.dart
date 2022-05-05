import 'package:app/models/Category.dart';
import 'package:app/services/Api.dart';
import 'package:flutter/widgets.dart';

class CategoryProvider extends ChangeNotifier {
  late ApiService apiService;
  List<Category> categories = [];

  CategoryProvider() {
    apiService = ApiService();

    init();
  }

  Future init() async {
    categories = await apiService.fetchCategories();
    notifyListeners();
  }

  Future updateCategory(Category cat) async {
    try {
      Category updatedCategory = await apiService.updateCategory(cat);
      int index = categories.indexOf(cat);

      categories[index] = updatedCategory;
      notifyListeners();
    } catch (Exception) {
      print(Exception);
    }
  }

  Future deleteCategory(Category cat) async {
    try {
      await apiService.deleteCategory(cat.id);
      categories.remove(cat);
      notifyListeners();
    } catch (Exception) {
      print(Exception);
    }
  }

  Future addCategory(String name) async {
    try {
      Category cat = await apiService.addCategory(name);
      categories.add(cat);
      notifyListeners();
    } catch (Exception) {
      print(Exception);
    }
  }
}
