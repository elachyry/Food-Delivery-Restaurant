import 'package:get/get.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';

class IngredientController extends GetxController {
  final IngredientRepository _ingrediantRepository =
      Get.put(IngredientRepository());

  RxList<Ingredient> ingrediants = RxList<Ingredient>();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ingrediants.bindStream(_ingrediantRepository.getIngredientStream().map(
        (query) =>
            query.docs.map((doc) => Ingredient.fromFirestore(doc)).toList()));
  }

  void addIngrediant(Ingredient ingredient) {
    isLoading.value = true;
    _ingrediantRepository.addIngrediant(ingredient);
    isLoading.value = false;
  }
}
