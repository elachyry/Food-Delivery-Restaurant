import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/size_config.dart';
import '../../controllers/controllers.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    super.key,
  });
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    var emailConroller = TextEditingController();
    var passwordConroller = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColorLight.withOpacity(0.1),
                  blurRadius: 20.0,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: Obx(
                    () => TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailConroller,
                      onChanged: (value) {
                        if (emailConroller.text.isNotEmpty) {
                          loginController.isCleanEmail.value = false;
                        } else {
                          loginController.isCleanEmail.value = true;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Email",
                        suffixIcon: loginController.isCleanEmail.value
                            ? null
                            : IconButton(
                                onPressed: () {
                                  emailConroller.clear();
                                  loginController.isCleanEmail.value = true;
                                },
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'The email field can\'t be empty.';
                        }
                        if (!value.contains('@')) {
                          return 'The email is not valid or badly formatted.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: loginController.isHidden.value,
                      textInputAction: TextInputAction.done,
                      controller: passwordConroller,
                      onChanged: (value) {
                        if (passwordConroller.text.isNotEmpty) {
                          loginController.isCleanPassword.value = false;
                        } else {
                          loginController.isCleanPassword.value = true;
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        border: InputBorder.none,
                        labelText: "Password",
                        suffixIcon: loginController.isCleanPassword.value
                            ? null
                            : InkWell(
                                onTap: () {
                                  loginController.isHidden.value =
                                      !loginController.isHidden.value;
                                },
                                child: Icon(
                                  loginController.isHidden.value
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'The password field can\'t be empty.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.snackbar('Forgot Password', 'Please Contact the admin',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue.shade400,
                    colorText: Colors.white,
                    duration: const Duration(milliseconds: 2000));
                // showModalBottomSheetForgotPassword(context);
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // AuthController.instance.isLoading.value
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     :
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.8),
                textStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              onPressed: loginController.isLoading.value
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        await loginController.signIn(
                            emailConroller.text.toLowerCase().trim(),
                            passwordConroller.text.trim());
                        // SignUpController.instance.registerUser(
                        //   controller.email.text.trim().toLowerCase(),
                        //   controller.password.text.trim(),
                        // );

                        // AuthController.instance.loginWithEmailAndPassword(
                        //   emailConroller.text.trim(),
                        //   passwordConroller.text,
                        // );
                      }
                    },
              child: Obx(
                () => loginController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        "Login",
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
