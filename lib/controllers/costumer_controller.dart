import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';

class CostumerController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final CostumerRepository _costumerRepo = Get.put(CostumerRepository());

  Stream<List<Costumer>> get restaurantStream => _costumerRepo.getCostumers();

  RxList<Costumer> costumers = <Costumer>[].obs;

  void loadCostumers() {
    restaurantStream.listen((costumersList) {
      costumers.value = costumersList;
    });
  }
}
