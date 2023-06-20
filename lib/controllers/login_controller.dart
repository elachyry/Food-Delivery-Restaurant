import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fde_restaurant_panel/dashboard.dart';
import 'package:fde_restaurant_panel/screens/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var isHidden = true.obs;
  var isCleanPassword = true.obs;
  var isCleanEmail = true.obs;

  late final Rx<User?> _firebaseUser;

  Rx<DocumentSnapshot?> userSnapshot = Rx<DocumentSnapshot?>(null);

  Rx<User?> get firebaseUser => _firebaseUser;
  // String? get userType => userSnapshot.value?.data()!['userType'];

  @override
  void onReady() {
    super.onReady();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    // ever(_firebaseUser, _initialScreen);
  }

  void _initialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(SignInScreen.appRoute);
    } else {
      // _getUserData(_firebaseUser.value!.uid);
      Get.offAllNamed(Dashboard.appRoute);
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   _auth.authStateChanges().listen((user) {
  //     _firebaseUser.value = user;
  //     if (user != null) {
  //       _getUserData(user.uid);
  //       if (userSnapshot.value!.exists) {
  //         Get.offAllNamed(Dashboard.appRoute);
  //       } else {
  //         Get.offAllNamed(SignInScreen.appRoute);
  //       }
  //     }
  //   });
  // }

  // void _getUserData(String uid) {
  //   _firestore.collection('restaurants').doc(uid).get().then((snapshot) {
  //     userSnapshot.value = snapshot;
  //   });
  // }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;

    try {
      var isExist = await isEmailExists(email);
      if (isExist) {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => Get.back());
      } else {
        showSnackBar(
            'Error', 'No account exists for that email.', Colors.red.shade500);
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;

      showSnackBar('Error', e.toString(), Colors.red.shade500);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      showSnackBar('Error', e.toString(), Colors.red.shade500);
    }
  }

  Future<bool> isEmailExists(String enteredEmail) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('restaurants').get();

    final List<QueryDocumentSnapshot> documents = snapshot.docs;

    for (final doc in documents) {
      final restaurantEmail = doc['email'];

      if (restaurantEmail == enteredEmail) {
        return true;
      }
    }

    return false;
  }

  void showSnackBar(String titleText, String messageText, Color color) {
    Get.snackbar(titleText, messageText,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 2000));
  }
}
