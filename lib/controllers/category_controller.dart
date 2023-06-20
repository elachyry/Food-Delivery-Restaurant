import 'package:get/get.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';

class CategoryController extends GetxController {
  final CategoryRepository _categoryRepository = Get.put(CategoryRepository());

  var isLoading = false.obs;

  RxList<Category> categories = RxList<Category>();

  @override
  void onInit() {
    super.onInit();
    categories.bindStream(_categoryRepository.getCategoryStream().map((query) =>
        query.docs.map((doc) => Category.fromFirestore(doc)).toList()));
  }

  void addCategory(Category category) {
    isLoading.value = true;
    _categoryRepository.addCategory(category);
    isLoading.value = false;
  }
}
